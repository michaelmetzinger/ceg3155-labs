library IEEE;
use IEEE.std_logic_1164.all;

entity reg_shiftr is
	generic (bits : integer := 1);
	port ( i_shift_in : in std_logic; --Data in
			i_shift : in std_logic; -- Shift
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1);
			o_shift_out : out std_logic);
end reg_shiftr;

architecture struct of reg_shiftr is

signal int_next_val : std_logic_vector(bits downto 0);

component reg is
	generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_load : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end component;


begin

int_next_val(bits) <= i_shift_in;

perbitloop: for i in 1 to bits generate	
	reg_i: reg port map (int_next_val(i downto i), i_shift, i_clock, int_next_val(bits-1 downto bits-1));
end generate;

o_data(bits downto 1) <= int_next_val(bits-1 downto 0);
o_shift_out <= int_next_val(0);

end struct;