library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_transmitter_controller is
end test_transmitter_controller;

architecture test of test_transmitter_controller is
signal i_reset : std_logic;
signal i_clock : std_logic := '0';
signal i_transmitByte : std_logic;
signal i_countDone	: std_logic;
signal o_setCounter : std_logic;
signal o_loadTDR : std_logic;
signal o_loadTSR: std_logic;
signal o_shiftTSR: std_logic;
signal o_enableTransmission: std_logic;
signal o_Tx_Busy: std_logic;

component transmitter_controller is
	port ( i_reset : in std_logic;
			 i_clock : in std_logic;
			 i_transmitByte : in std_logic;
			 i_countDone	: in std_logic;
			 o_setCounter : out std_logic;
			 o_loadTDR : out std_logic;
			 o_loadTSR: out std_logic;
			 o_shiftTSR: out std_logic;
			 o_enableTransmission: out std_logic;
			 o_Tx_Busy: out std_logic);
end component;

begin

impl: transmitter_controller port map(i_reset, i_clock, i_transmitByte, i_countDone, o_setCounter, o_loadTDR, o_loadTSR, o_shiftTSR, o_enableTransmission, o_tx_Busy);

i_clock <= not(i_clock) after 1 ns;

stimulus: process begin
      i_reset <= '0';
		i_transmitByte <= '0';
		i_countDone <= '0';
		wait for 5 ns;
		i_reset <= '1';
		wait for 5 ns;
		i_reset <= '0';
		wait for 5 ns;
		i_transmitByte <= '1';
		wait for 5 ns;
		i_transmitByte <= '0';
		wait for 30 ns;
		i_countDone <= '1';
		wait for 5 ns;
		i_countDone <= '0';
    end process;	
end test;