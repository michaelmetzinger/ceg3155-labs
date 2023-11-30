library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_parity_generator is
end test_parity_generator;

architecture test of test_parity_generator is
signal i_input : std_logic_vector(6 downto 0);
signal o_even_parity: std_logic;
signal o_odd_parity: std_logic;

component parity_generator is
	port(
		i_input : in std_logic_vector(6 downto 0);
		o_evenParity: out std_logic;
		o_oddParity : out std_logic);
end component;

begin

impl: parity_generator port map(i_input, o_even_parity, o_odd_parity);


stimulus: process begin
        for i in 0 to 127 loop
            i_input <= std_logic_vector(to_unsigned(i, 7));
            wait for 5 ns;
        end loop;
        wait;
    end process;	
end test;