LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity or8x2 is
    port(i_a, i_b : in std_logic_vector(7 downto 0);
        o : out std_logic_vector(7 downto 0));
end or8x2;

architecture struct of or8x2 is
begin

	orloop: for i in 0 to 7 generate
    o(i) <= i_a(i) or i_b(i);
	 
	end generate;
end struct;