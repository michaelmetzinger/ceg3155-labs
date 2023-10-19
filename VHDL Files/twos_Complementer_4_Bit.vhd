library ieee;
use ieee.std_logic_1164.all;


entity twos_Complementer_4_Bit is
	port(	i_input 	: in std_logic_vector(3 downto 0);
			o_output	: out std_logic_vector(3 downto 0));
end twos_Complementer_4_Bit;

architecture struct of twos_Complementer_4_Bit is
signal int_output : std_logic_vector(3 downto 0);

component add_sub_4 is
 port(i_a, i_b : in std_logic_vector(3 downto 0);
    	i_op : in std_logic; -- 0 add 1 sub
      o_sum : out std_logic_vector(3 downto 0);
      o_carry, o_overflow : out std_logic);
end component;

begin

complementer: add_sub_4
	port map ("0000", i_input, '1',
    	int_output, OPEN, OPEN);
		
o_output <= int_output;

end struct;