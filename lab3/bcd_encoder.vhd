library IEEE;
use IEEE.std_logic_1164.all;

entity bcd_encoder is
	port(input : in std_logic_vector(3 downto 0);
			o_tens, o_ones : out std_logic_vector(3 downto 0));
end bcd_encoder;

architecture struct of bcd_encoder is

begin
o_tens(3) <= '0';
o_tens(2) <= '0';
o_tens(1) <= '0';
o_tens(0) <= (input(3) and input(2)) or (input(3) and input(1));

o_ones(3) <= input(3) and not(input(2)) and not(input(1));
o_ones(2) <= (not(input(3)) and input(2)) or (input(3) and input(2) and input(1));
o_ones(1) <= (not(input(3)) and input(1)) or (input(3) and input(2) and not(input(1)));
o_ones(0) <= input(0);

end struct;