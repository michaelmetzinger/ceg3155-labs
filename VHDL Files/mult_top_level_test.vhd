library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult_top_level_test is
end mult_top_level_test;

architecture test of mult_top_level_test is
signal clock : std_logic := '0';
signal reset : std_logic;
signal a,b	 :	std_logic_vector(3 downto 0);
signal output: std_logic_vector(7 downto 0);

component signed_4_Bit_Multiplier is
	PORT(
				--Inputs--
		i_InputA, i_InputB								: IN	STD_LOGIC_VECTOR( 3 downto 0);
		i_GReset												: IN	STD_LOGIC;
		i_clock												: IN	STD_LOGIC;		
		--Outputs--
		o_Output : OUT STD_LOGIC_VECTOR (7 downto 0));
end component;

begin

impl: signed_4_Bit_Multiplier port map(a, b, reset, clock, output);

clock <= not(clock) after 1 ns;
reset <= '1', '0' after 20 ns;

stimulus: process begin
	wait until reset = '0';
	
	for i in -8 to 7 loop
		for j in -8 to 7 loop
			a <= std_logic_vector(to_signed(i,4));
			b <= std_logic_vector(to_signed(j,4));
			wait for 70 ns;
			

		end loop;
	end loop;


	
end process;	
end test;