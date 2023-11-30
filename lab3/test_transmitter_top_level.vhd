library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_transmitter_top_level is
end test_transmitter_top_level;

architecture test of test_transmitter_top_level is
signal i_reset : std_logic;
signal i_clock : std_logic := '0';
signal i_data: std_logic_vector (6 downto 0) := "1000100";
signal i_transmitByte : std_logic;

signal o_Tx_Busy: std_logic;
signal o_TxData: std_logic;

component transmitter_top_level is
	port ( i_reset: in std_logic;
			 i_clock: in std_logic;
			 i_data: in std_logic_vector(6 downto 0);
			 i_transmitByte: in std_logic;
			 o_Tx_Busy: out std_logic;
			 o_TxData: out std_logic);
end component;

begin

impl: transmitter_top_level port map(i_reset, i_clock, i_data, i_transmitByte, o_Tx_Busy, o_TxData);

i_clock <= not(i_clock) after 1 ns;

stimulus: process begin
		wait for 5 ns;
		i_reset <= '1';
		i_transmitByte <= '0';
		wait for 5 ns;
		i_reset <= '0';
		wait for 5 ns;
		i_transmitByte <= '1';
		wait for 5 ns;
		i_transmitByte <= '0';
		wait for 20 ns;
		i_data<= std_logic_vector(unsigned(i_data)+1);
    end process;	
end test;