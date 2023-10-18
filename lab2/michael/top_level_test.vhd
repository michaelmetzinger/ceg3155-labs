library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_test is
end top_level_test;

architecture test of top_level_test is
signal clock : std_logic := '0';
signal reset, carry, zero, overflow : std_logic;
signal a,b : std_logic_vector(3 downto 0);
signal op : std_logic_vector(1 downto 0);
signal o : std_logic_vector(7 downto 0);

component top_level is
	port(
		i_g_clock, i_g_reset : in std_logic;
		i_operand_a, i_operand_b : in std_logic_vector(3 downto 0);
		i_operation_selection : in std_logic_vector(1 downto 0);
		o_mux : out std_logic_vector(7 downto 0);
		o_carry, o_zero, o_overflow : out std_logic
	);
end component;

begin
clock <= not(clock) after 1 ns;
reset <= '1', '0' after 10 ns;

top_level_instance: top_level
	port map (clock, reset,
		a,b,
		op,
		o,
		carry, zero, overflow);

simulate: process begin
	for op_i in 0 to 3 loop
		for i in -8 to 7 loop
			for j in -8 to 7 loop
				a <= std_logic_vector(to_signed(i,4));
				b <= std_logic_vector(to_signed(j,4));
				op <= std_logic_vector(to_unsigned(op_i, 2));
				wait for 50 ns;
			end loop;
		end loop;
	end loop;
end process;
end test;