library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_add_sub_4 is
end entity;

architecture test of test_add_sub_4 is
signal a, b : std_logic_vector(3 downto 0);
signal op : std_logic;
signal sum : std_logic_vector(3 downto 0);
signal carry, overflow : std_logic;
component add_sub_4 is
	port(i_a, i_b : in std_logic_vector(3 downto 0);
		  i_op : in std_logic;
        o_sum : out std_logic_vector(3 downto 0);
        o_carry, o_overflow : out std_logic);
end component;
begin

add_sub: add_sub_4 port map(a,b,op,sum,carry,overflow);

stimulus:
	process begin
	op <= '0'; -- add
	for i in -8 to 7 loop
		for j in -8 to 7 loop
			a <= std_logic_vector(to_signed(i,4));
			b <= std_logic_vector(to_signed(j,4));
			wait for 1 ns;
			
			assert sum = std_logic_vector(to_signed(i,4)+to_signed(j,4));
			
			if (to_signed(i,5) + to_signed(j,5)) > 7 then
				assert overflow = '1';
			elsif (to_signed(i,5) + to_signed(j,5)) < -8 then
				assert overflow = '1';
			else
				assert overflow = '0';
			end if;
		end loop;
	end loop;
	
	op <= '1'; -- sub
	for i in -8 to 7 loop
		for j in -8 to 7 loop
			a <= std_logic_vector(to_signed(i,4));
			b <= std_logic_vector(to_signed(j,4));
			wait for 1 ns;
			
			assert sum = std_logic_vector(to_signed(i,4)-to_signed(j,4));
			
			if (to_signed(i,5) - to_signed(j,5)) > 7 then
				assert overflow = '1';
			elsif (to_signed(i,5) - to_signed(j,5)) < -8 then
				assert overflow = '1';
			else
				assert overflow = '0';
			end if;
		end loop;
	end loop;
	
	end process;

end test;