library IEEE;
use IEEE.std_logic_1164.all;

entity counter_4 is
	port(i_clock, i_clear : in std_logic;
			output : out std_logic_vector(3 downto 0));
end counter_4;

architecture struct of counter_4 is

signal int_out, int_next, mux_to_ff : std_logic_vector(3 downto 0);

COMPONENT MUX_2_To_1 IS
	PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC;
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC);
END COMPONENT;

component dFF_2 IS
	PORT(
		i_d		: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END component;

begin

mux_dff_gen: for i in 0 to 3 generate
	mux_i: MUX_2_To_1 port map('0', int_next(i), i_clear, mux_to_ff(i));
	dff_i: dFF_2 port map(i_d => mux_to_ff(i), i_clock => i_clock, o_q => int_out(i));
end generate;

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
