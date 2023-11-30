library IEEE;
use IEEE.std_logic_1164.all;

entity counter_4_inc is
	port(i_clock, i_clear, i_inc : in std_logic;
			output : out std_logic_vector(3 downto 0));
end counter_4_inc;

architecture struct of counter_4_inc is

signal int_out, int_next, mux_to_ff : std_logic_vector(3 downto 0);
signal int_load : std_logic;

COMPONENT MUX_2_To_1 IS
	PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC;
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC);
END COMPONENT;

component reg is
	generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_load : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end component;

begin

mux_dff_gen: for i in 0 to 3 generate
	mux_i: MUX_2_To_1 port map('0', int_next(i), i_clear, mux_to_ff(i));
	reg_i: reg port map(mux_to_ff(i downto i), int_load, i_clock, int_out(i downto i));
end generate;

int_load <= i_inc or i_clear;

int_next(3) <= int_out(3) 
					or (int_out(2) and int_out(1) and int_out(0));
int_next(2) <= (not(int_out(2)) and int_out(1) and int_out(0))
					or (int_out(2) and not(int_out(1)))
					or (int_out(3) and int_out(2))
					or (int_out(2) and not(int_out(0)));
int_next(1) <= (not(int_out(1)) and int_out(0)) 
					or (int_out(1) and not(int_out(0))) 
					or (int_out(3) and int_out(2) and int_out(1));
int_next(0) <= not(int_out(0)) 
					or (int_out(3) and int_out(2) and int_out(1));

output <= int_out;

end struct;
