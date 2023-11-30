library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_fsm_test is
end uart_fsm_test;

architecture test of uart_fsm_test is
signal clock : std_logic := '0';
signal tx_ready : std_logic;
signal reset, transmit_byte : std_logic;
signal light_state : std_logic_vector(1 downto 0);
signal transmit_data : std_logic_vector(6 downto 0);

component uart_fsm is
	port(i_clock, i_reset, i_tx_ready : in std_logic;
		i_light_state : in std_logic_vector(1 downto 0);
		o_transmit_byte : out std_logic;
		o_transmit_data : out std_logic_vector(6 downto 0));
end component;

begin

impl: uart_fsm port map(clock, reset, tx_ready, light_state, transmit_byte, transmit_data);

clock <= not(clock) after 0.5 ns;

stimulus: process begin
	reset <= '1';
	tx_ready <= '1';
	light_state <= "00";
	wait for 5 ns;
	reset <= '0';
	
	for i in 1 to 6 loop
		wait until transmit_byte = '1';
		wait for 1 ns;
		tx_ready <= '0';
		wait for 8 ns;
		tx_ready <= '1';
	end loop;
	
	wait for 10 ns;
	light_state <= "01";
	for i in 1 to 6 loop
		wait until transmit_byte = '1';
		wait for 1 ns;
		tx_ready <= '0';
		wait for 8 ns;
		tx_ready <= '1';
	end loop;
	
	wait for 10 ns;
	light_state <= "10";
	for i in 1 to 6 loop
		wait until transmit_byte = '1';
		wait for 1 ns;
		tx_ready <= '0';
		wait for 8 ns;
		tx_ready <= '1';
	end loop;
	
	wait for 10 ns;
	light_state <= "11";
	for i in 1 to 6 loop
		wait until transmit_byte = '1';
		wait for 1 ns;
		tx_ready <= '0';
		wait for 8 ns;
		tx_ready <= '1';
	end loop;
	
	wait for 10 ns;
end process;	
end test;