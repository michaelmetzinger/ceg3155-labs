library IEEE;
use IEEE.std_logic_1164.all;

entity div_data is
	port (
		i_a, i_b : std_logic_vector(3 downto 0);
		i_clock : in std_logic;
		i_r_load, i_r_sel, 
		i_d_sel, i_d_load, i_d_shiftr, 
		i_q_shift_in, i_q_load, i_q_clear, i_q_shiftl,
		i_add_left_sel	: in std_logic;
		i_add_right_sel : in std_logic_vector(1 downto 0);
		i_addbar_sub,
		i_neg_load, i_neg_clear,
		i_output_load : in std_logic;
		
		o_gt : out std_logic;
		o_neg : out std_logic;
		o_neg_a, o_neg_b : out std_logic;
		o_output, o_remainder : out std_logic_vector(3 downto 0)
	);
		
end div_data;

architecture struct of div_data is
signal int_r_sel_output : std_logic_vector(3 downto 0);
signal int_r_reg_output : std_logic_vector(3 downto 0);

signal int_d_sel_output : std_logic_vector(6 downto 0);
signal int_d_reg_output : std_logic_vector(6 downto 0);

signal int_q_reg_output : std_logic_vector(3 downto 0);

signal int_add_left_sel_output : std_logic_vector(3 downto 0);
signal int_add_right_sel_output : std_logic_vector(3 downto 0);
signal int_add_out : std_logic_vector(3 downto 0);

signal int_output, int_output_remainder : std_logic_vector(3 downto 0);

signal int_gt : std_logic;

signal int_neg_output, int_neg_output_bar : std_logic;

signal int_add_out_padded, int_b_padded, int_r_reg_output_padded : std_logic_vector(6 downto 0);

component reg
generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_load : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end component;

component reg_load_shiftr is
	generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_load, i_shiftr : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end component;

component reg_load_clear_shiftl_shiftr is
	generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_shift_in : in std_logic;
			i_load, i_clear, i_shiftr, i_shiftl : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end component;

component MUX_2_To_1_n IS
	GENERIC(bits : integer := 2);
	PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC_VECTOR(bits downto 1);
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC_VECTOR(bits downto 1));
END component;

component MUX_4_To_1_n IS
	GENERIC(bits : integer := 2);
	PORT(
		i_0, i_1, i_2, i_3 : IN	STD_LOGIC_VECTOR(bits downto 1);
		i_Selector 		: IN	STD_LOGIC_VECTOR(1 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(bits downto 1));
END component;

component add_sub_4 is
	port(i_a, i_b : in std_logic_vector(3 downto 0);
    	i_op : in std_logic; -- 0 add 1 sub
      o_sum : out std_logic_vector(3 downto 0);
      o_carry, o_overflow : out std_logic);
end component;

component cmp is
	generic (bits : integer := 2); --must be 2 or greater. use cmp_1 for 1 bit.
	port (i_a, i_b : in std_logic_vector(bits downto 1);
			o_gt, o_eq, o_lt : out std_logic);
end component;

component reg_clear is
	generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_load, i_clear : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end component;

begin

r_mux: MUX_2_To_1_n
	generic map (bits => 4)
	port map (int_add_out, i_a, i_r_sel, int_r_sel_output);

r_reg: reg
	generic map (bits => 4)
	port map (int_r_sel_output, i_r_load, i_clock, int_r_reg_output);

int_add_out_padded <= int_add_out & "000";
int_b_padded <= i_b & "000";
d_mux: MUX_2_To_1_n
	generic map (bits => 7)
	port map (int_add_out_padded, int_b_padded, i_d_sel, int_d_sel_output);

d_reg: reg_load_shiftr
	generic map (bits => 7)
	port map (int_d_sel_output, i_d_load, i_d_shiftr, i_clock, int_d_reg_output);
	
q_reg: reg_load_clear_shiftl_shiftr
	generic map (bits => 4)
	port map (int_add_out, i_q_shift_in, i_q_load, i_q_clear, '0', i_q_shiftl, i_clock, int_q_reg_output);
	
add_left_mux: MUX_2_To_1_n
	generic map (bits => 4)
	port map (int_r_reg_output, "0000", i_add_left_sel, int_add_left_sel_output);
	
add_right_mux: MUX_4_To_1_n
	generic map (bits => 4)
	port map (i_a, i_b, int_d_reg_output(3 downto 0), int_q_reg_output, i_add_right_sel, int_add_right_sel_output);

add_sub: add_sub_4
	port map (i_a => int_add_left_sel_output, i_b => int_add_right_sel_output, i_op => i_addbar_sub, o_sum => int_add_out);

int_r_reg_output_padded <= "000" & int_r_reg_output;
cmp_d_r: cmp
	generic map (bits => 7)
	port map (i_a => int_d_reg_output, i_b => int_r_reg_output_padded, o_gt => int_gt);

int_neg_output_bar <= not(int_neg_output);
reg_neg: reg_clear
	generic map (bits => 1)
	port map (i_data(1) => int_neg_output_bar, i_load => i_neg_load, i_clear => i_neg_clear, i_clock => i_clock, o_data(1) => int_neg_output);

reg_output: reg
	generic map (bits => 4)
	port map (int_q_reg_output, i_output_load, i_clock, int_output);

reg_remainder_output: reg
	generic map (bits => 4)
	port map (int_r_reg_output, i_output_load, i_clock, int_output_remainder);

o_gt <= int_gt;
o_neg <= int_neg_output;
o_neg_a <= i_a(3);
o_neg_b <= i_b(3);
o_output <= int_output;
o_remainder <= int_output_remainder;
end struct;