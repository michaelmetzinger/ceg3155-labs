library ieee;
use ieee.std_logic_1164.all;

entity add_sub_8 is
	port(i_a, i_b : in std_logic_vector(7 downto 0);
    	i_op : in std_logic; -- 0 add 1 sub
      o_sum : out std_logic_vector(7 downto 0);
      o_carry, o_overflow : out std_logic);
end add_sub_8;

architecture struct of add_sub_8 is
signal int_b, int_carry, int_sum : std_logic_vector(7 downto 0);

component full_addr_1 is
 port(i_a,i_b,i_carry : in std_logic;
    	o_carry, o_sum : out std_logic);
end component;

begin

xorloop: for i in 0 to 7 generate
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
		
addr4: full_addr_1
	port map (i_a(4), int_b(4), int_carry(3),
    	int_carry(4), int_sum(4));
		
addr5: full_addr_1
	port map (i_a(5), int_b(5), int_carry(4),
    	int_carry(5), int_sum(5));
		
addr6: full_addr_1
	port map (i_a(6), int_b(6), int_carry(5),
    	int_carry(6), int_sum(6));
		
addr7: full_addr_1
	port map (i_a(7), int_b(7), int_carry(6),
    	int_carry(7), int_sum(7));		

o_carry <= int_carry(7);
o_overflow <= int_carry(7) xor int_carry(6);
o_sum <= int_sum;

end struct;
