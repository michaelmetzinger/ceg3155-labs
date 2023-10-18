library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity div_top_level_test is
end div_top_level_test;

architecture test of div_top_level_test is
signal clock : std_logic := '0';
signal reset : std_logic;
signal a,b,output, remainder : std_logic_vector(3 downto 0);

component div_top_level is
	port (i_a,i_b : in std_logic_vector(3 downto 0);
			i_clock, i_reset : in std_logic;
			o_output, o_remainder : out std_logic_vector(3 downto 0)
		);
end component;

begin

impl: div_top_level port map(a, b, clock, reset, output, remainder);

clock <= not(clock) after 1 ns;
reset <= '1', '0' after 20 ns;

stimulus: process begin
	wait until reset = '0';
	
	for i in -8 to 7 loop
		for j in -8 to 7 loop
			a <= std_logic_vector(to_signed(i,4));
			b <= std_logic_vector(to_signed(j,4));
			wait for 50 ns;
			

		end loop;
	end loop;


	
end process;	
end test;