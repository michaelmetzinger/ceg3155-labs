library IEEE;
use IEEE.std_logic_1164.all;

entity cmp_1 is
	port (i_a, i_b : in std_logic;
			o_gt, o_eq, o_lt : out std_logic);
end cmp_1;

architecture struct of cmp_1 is
begin
o_gt <= i_a and not(i_b);
o_eq <= i_a xnor i_b;
o_lt <= not(i_a) and i_b;
end struct;

library IEEE;
use IEEE.std_logic_1164.all;

entity cmp is
	generic (bits : integer := 2); --must be 2 or greater. use cmp_1 for 1 bit.
	port (i_a, i_b : in std_logic_vector(bits downto 1);
			o_gt, o_eq, o_lt : out std_logic);
end cmp;

architecture struct of cmp is

signal int_gt, int_eq, int_lt : std_logic_vector(bits downto 1);
signal int_a, int_b : std_logic_vector(bits-1 downto 1);

component cmp_1 is
	port (i_a, i_b : in std_logic;
			o_gt, o_eq, o_lt : out std_logic);
end component;

begin

cmp_msb: cmp_1 port map (i_a(bits), i_b(bits), int_gt(bits), int_eq(bits), int_lt(bits));

cmp_loop: for i in 1 to bits-1 generate
  int_a(i) <= int_gt(i+1) or (i_a(i) and int_eq(i+1));
  int_b(i) <= int_lt(i+1) or (i_b(i) and int_eq(i+1));
	cmp_i: cmp_1 port map (
		int_a(i),
		int_b(i),
		int_gt(i), int_eq(i), int_lt(i));
end generate;

o_gt <= int_gt(1);
o_eq <= int_eq(1);
o_lt <= int_lt(1);

end struct;