library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_encoder_test is
end bcd_encoder_test;

architecture test of bcd_encoder_test is
signal upper, lower, input : std_logic_vector(3 downto 0);

component bcd_encoder is
	port(input : in std_logic_vector(3 downto 0);
			o_tens, o_ones : out std_logic_vector(3 downto 0));
end component;

begin

impl: bcd_encoder
	port map(input, upper, lower);

stimulus: process begin
	for i in 0 to 15 loop
		input <= std_logic_vector(to_unsigned(i,4));
		wait for 1 ns;
	end loop;
end process;	
end test;