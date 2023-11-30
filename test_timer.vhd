library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_timer is
end test_timer;

architecture test of test_timer is
signal clock : std_logic := '0';
signal clear : std_logic;
signal output : std_logic_vector(3 downto 0);

component timer is
	port(i_clock, i_clear : in std_logic;
			output : out std_logic_vector(3 downto 0));
end component;

begin

impl: timer
	port map(clock, clear, output);

clock <= not(clock) after 1 ns;


stimulus: process begin
	clear <= '1';
	wait for 5 ns;
	clear <= '0';
	wait for 32 ns;
end process;	
end test;