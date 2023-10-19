library ieee;
use ieee.std_logic_1164.all;

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