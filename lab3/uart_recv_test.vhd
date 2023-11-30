library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_recv_test is
end uart_recv_test;

architecture test of uart_recv_test is
signal clock : std_logic := '0';
signal RxD, RIE, reset : std_logic;

signal RDR : std_logic_vector(6 downto 0);
signal OE, FE, RDRF : std_logic;

component uart_recv is
	port(
		i_RxD, i_RIE, i_clock, i_reset : in std_logic;
		o_RDR : out std_logic_vector(6 downto 0);
		o_OE, o_FE, o_RDRF : out std_logic
	);
end component;

begin

impl: uart_recv
	port map(RxD, RIE, clock, reset, 
				RDR, 
				OE, FE, RDRF);

clock <= not(clock) after 62.5 ps; --1/8 a ns clock cycle


stimulus: process begin
	reset <= '1';
	RxD <= '1';
	RIE <= '0';
	wait for 5 ns;
	
	reset <= '0';
	wait for 5 ns; --stay in idle
	
	--data 0 1010101 0 1
	RxD <= '0';
	wait for 1 ns;
	RxD <= '1';
	wait for 1 ns;
	RxD <= '0';
	wait for 1 ns;
	RxD <= '1';
	wait for 1 ns;
	RxD <= '0';
	wait for 1 ns;
	RxD <= '1';
	wait for 1 ns;
	RxD <= '0';
	wait for 1 ns;
	RxD <= '1';
	wait for 1 ns;
	RxD <= '0';
	wait for 1 ns;
	RxD <= '1';
	wait for 10 ns;
	
	RIE <= '1'; --read 
	wait for 1 ns;
	RIE <= '0';
	
	--data 0 1111000 0 1 expect 0001111 as RDR
	RxD <= '0';
	wait for 1 ns;
	RxD <= '1';
	wait for 1 ns;
	RxD <= '1';
	wait for 1 ns;
	RxD <= '1';
	wait for 1 ns;
	RxD <= '1';
	wait for 1 ns;
	RxD <= '0';
	wait for 1 ns;
	RxD <= '0';
	wait for 1 ns;
	RxD <= '0';
	wait for 1 ns;
	RxD <= '0';
	wait for 1 ns;
	RxD <= '1';
	wait for 10 ns;
	
	--data 0 0001111 0 1 expect 1111000 as RDR
	RxD <= '0';
	wait for 1 ns;
	RxD <= '0';
	wait for 1 ns;
	RxD <= '0';
	wait for 1 ns;
	RxD <= '0';
	wait for 1 ns;
	RxD <= '1';
	wait for 1 ns;
	RxD <= '1';
	wait for 1 ns;
	RxD <= '1';
	wait for 1 ns;
	RxD <= '1';
	wait for 1 ns;
	RxD <= '0';
	wait for 1 ns;
	RxD <= '1';
	wait for 10 ns; --should get OE
	
	reset <= '1';
	wait for 1 ns;
	reset <= '0';
	wait for 1 ns;
	RxD <= '0';
	wait for 15 ns; -- should get FE
	
	
end process;	
end test;