library IEEE;
use IEEE.std_logic_1164.all;

entity full_addr_1 is
	port(i_a,i_b,i_carry : in std_logic;
    	o_carry, o_sum : out std_logic);
end full_addr_1;

architecture struct of full_addr_1 is
signal int_axorb : std_logic;
begin
int_axorb <= i_a xor i_b;

o_carry <= (i_a and i_b) or (int_axorb and i_carry);
o_sum <= int_axorb xor i_carry;
end struct;

library ieee;
use ieee.std_logic_1164.all;

entity add_sub_4 is
	port(i_a, i_b : in std_logic_vector(3 downto 0);
    	i_op : in std_logic; -- 0 add 1 sub
      o_sum : out std_logic_vector(3 downto 0);
      o_carry, o_overflow : out std_logic);
end add_sub_4;

architecture struct of add_sub_4 is
signal int_b, int_carry, int_sum : std_logic_vector(3 downto 0);

component full_addr_1 is
 port(i_a,i_b,i_carry : in std_logic;
    	o_carry, o_sum : out std_logic);
end component;

begin

xorloop: for i in 0 to 3 generate
	int_b(i) <= i_b(i) xor i_op;
end generate;

addr0: full_addr_1
	port map (i_a(0), int_b(0), i_op,
    	int_carry(0), int_sum(0));

addr1: full_addr_1
	port map (i_a(1), int_b(1), int_carry(0),
    	int_carry(1), int_sum(1));

addr2: full_addr_1
	port map (i_a(2), int_b(2), int_carry(1),
    	int_carry(2), int_sum(2));

addr3: full_addr_1
	port map (i_a(3), int_b(3), int_carry(2),
    	int_carry(3), int_sum(3));

o_carry <= int_carry(3);
o_overflow <= int_carry(3) xor int_carry(2);
o_sum <= int_sum;

end struct;
