library IEEE;
use IEEE.std_logic_1164.all;

entity top_level is
	port(
		i_g_clock, i_g_reset : in std_logic;
		i_operand_a, i_operand_b : in std_logic_vector(3 downto 0);
		i_operation_selection : in std_logic_vector(1 downto 0);
		o_mux : out std_logic_vector(7 downto 0);
		o_carry, o_zero, o_overflow : out std_logic
	);
end top_level;

architecture struct of top_level is
signal int_mux_input_add, int_mux_input_sub, int_mux_input_mult, int_mux_input_div,
	int_mux_output : std_logic_vector(7 downto 0);
signal int_add_carry, int_sub_carry, int_mult_carry, int_div_carry, int_carry_out : std_logic;
signal int_add_overflow, int_sub_overflow, int_mult_overflow, int_div_overflow, int_overflow_out : std_logic;
signal int_zero : std_logic;

component MUX_4_To_1_n IS
	GENERIC(bits : integer := 2);
	PORT(
		i_0, i_1, i_2, i_3 : IN	STD_LOGIC_VECTOR(bits downto 1);
		i_Selector 		: IN	STD_LOGIC_VECTOR(1 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(bits downto 1));
END component;

component MUX_4_To_1 IS
	PORT(
		i_0, i_1,i_2,i_3			: IN	STD_LOGIC;
		i_Selector 		: IN	STD_LOGIC_VECTOR(1 downto 0);
		o_Value			: OUT	STD_LOGIC);
end component;

component add_sub_4 is
	port(i_a, i_b : in std_logic_vector(3 downto 0);
    	i_op : in std_logic; -- 0 add 1 sub
      o_sum : out std_logic_vector(3 downto 0);
      o_carry, o_overflow : out std_logic);
end component;

component div_top_level is
	port (
		i_a, i_b : in std_logic_vector(3 downto 0);
		i_clock, i_reset : in std_logic;
		o_output, o_remainder : out std_logic_vector(3 downto 0)
	);
end component;

begin

int_mux_input_add(7 downto 4) <= "0000";
int_mux_input_sub(7 downto 4) <= "0000";

adder: add_sub_4
	port map (i_operand_a, i_operand_b,
		i_operation_selection(0),
		int_mux_input_add(3 downto 0),
		int_add_carry, int_add_overflow
	);

int_mux_input_sub <= int_mux_input_add;
int_sub_carry <= int_add_carry;
int_sub_overflow <= int_add_overflow;

div: div_top_level
	port map (i_operand_a, i_operand_b,
		i_g_clock, i_g_reset,
		int_mux_input_div(3 downto 0), int_mux_input_div(7 downto 4));

int_div_carry <= '0';
int_div_overflow <= '0';

-- TODO div overflow/carry (0?)
-- TODO mult
		
sel_output_mux: MUX_4_To_1_n
	generic map (bits => 8)
	port map (int_mux_input_add, int_mux_input_sub, int_mux_input_mult, int_mux_input_div,
		i_operation_selection,
		int_mux_output
	);	

sel_carry: MUX_4_To_1
	port map(int_add_carry, int_sub_carry, int_mult_carry, int_div_carry,
		i_operation_selection,
		int_carry_out);

sel_overflow: MUX_4_To_1
	port map(int_add_overflow, int_sub_overflow, int_mult_overflow, int_div_overflow,
		i_operation_selection,
		int_overflow_out);

int_zero <= not(int_mux_output(0) or int_mux_output(1) or int_mux_output(2) or int_mux_output(3) or 
	int_mux_output(4) or int_mux_output(5) or int_mux_output(6) or int_mux_output(7));


o_mux <= int_mux_output;
o_carry <= int_carry_out;
o_overflow <= int_overflow_out;
o_zero <= int_zero;
end struct;