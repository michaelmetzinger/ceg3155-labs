library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_cmp is
end test_cmp;

architecture test of test_cmp is
signal i_a : std_logic_vector(4 downto 1);
signal i_b : std_logic_vector(4 downto 1);
signal o_gt: std_logic;
signal o_eq: std_logic;
signal o_lt: std_logic;

component cmp is
	generic (bits : integer := 2); --must be 2 or greater. use cmp_1 for 1 bit.
	port (i_a, i_b : in std_logic_vector(bits downto 1);
			o_gt, o_eq, o_lt : out std_logic);
end component;

begin

impl: cmp generic map(bits => 4)
	port map(i_a, i_b, o_gt, o_eq, o_lt);


stimulus: process begin
	i_a <= "1001";
	i_b <= "1000";
	wait for 5 ns;
	i_b <= "1010";
	wait for 32 ns;
end process;	
end test;