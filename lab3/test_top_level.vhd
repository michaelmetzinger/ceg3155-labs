library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_top_level is
end test_top_level;

architecture test of test_top_level is
signal clock : std_logic := '0';
signal reset, sscs : std_logic;
signal msc, ssc, bcd1, bcd2 : std_logic_vector(3 downto 0);
signal mstl, sstl : std_logic_vector(2 downto 0);

component top_level is
	port(i_gclock, i_greset : in std_logic;
			i_msc, i_ssc : in std_logic_vector(3 downto 0);
			i_sscs : in std_logic;
			o_mstl, o_sstl : out std_logic_vector(2 downto 0);
			o_bcd1, o_bcd2 : out std_logic_vector(3 downto 0) --left, right diget
		 );
end component;

begin

impl: top_level
	port map(clock, reset, msc, ssc, sscs, mstl, sstl, bcd1, bcd2);

clock <= not(clock) after 1 ns;


stimulus: process begin
	msc <= "1000";
	ssc <= "0100";
	sscs <= '0';
	
	reset <= '1';
	wait for 5 ns;
	
	reset <= '0';
	wait for 64 ns;
	
	sscs <= '1';
	wait for 100 ns;
	
	sscs <= '0';
	wait for 64 ns;
	sscs <= '1';
	wait for 5 ns;
	sscs <= '0';
	wait for 64 ns;
end process;	
end test;