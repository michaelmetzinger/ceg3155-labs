library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_regs is
end test_regs;

architecture test of test_regs is
signal clock : std_logic := '0';
signal load : std_logic;
signal data, output : std_logic_vector(3 downto 0);

component reg is
	generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_load : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end component;

begin

impl: reg generic map(4)
	port map(data, load, clock, output);

clock <= not(clock) after 1 ns;


stimulus: process begin
	load <= '1';
	data <= "0000";
	wait for 5 ns;
	
	data <= "1111";
	wait for 5 ns;
	
	data <= "1010";
	wait for 5 ns;

	data <= "0101";
	wait for 5 ns;
	load <= '0';
	wait for 1 ns;
	data <= "0000";
	wait;
end process;	
end test;