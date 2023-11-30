library IEEE;
use IEEE.std_logic_1164.all;

entity parity_generator is
	port(
		i_input : in std_logic_vector(6 downto 0);
		o_evenParity: out std_logic;
		o_oddParity : out std_logic);
end parity_generator;
		
architecture struct of parity_generator is
	signal int_first_xor : std_logic;
	signal int_second_xor : std_logic;
	signal int_third_xor : std_logic;
	signal int_fourth_xor : std_logic;
	signal int_fifth_xor : std_logic;
	signal int_sixth_xor : std_logic;
	
begin
	int_first_xor <= i_input(0) xor i_input(1);
	int_second_xor <= i_input(2) xor int_first_xor;
	int_third_xor <= i_input(3) xor int_second_xor;
	int_fourth_xor <= i_input(4) xor int_third_xor;
	int_fifth_xor <= i_input(5) xor int_fourth_xor;
	int_sixth_xor <= i_input(6) xor int_fifth_xor;

	o_evenParity <= int_sixth_xor;
	o_oddParity <= not(int_sixth_xor);
	
end struct;
	
	
	
	
	