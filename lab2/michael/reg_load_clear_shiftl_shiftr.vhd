library IEEE;
use IEEE.std_logic_1164.all;

entity reg_load_clear_shiftl_shiftr is
	generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_shift_in : in std_logic;
			i_load, i_clear, i_shiftr, i_shiftl : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end reg_load_clear_shiftl_shiftr;

architecture struct of reg_load_clear_shiftl_shiftr is
signal int_in : std_logic_vector(bits downto 1);
signal int_out : std_logic_vector(bits+1 downto 0);
signal sel0, sel1, int_reg_load : std_logic;

component reg is
	generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_load : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end component;
component MUX_4_To_1 IS
	port(
		i_0, i_1,i_2,i_3 : IN std_LOGIC;
		i_Selector 		: IN	STD_LOGIC_VECTOR(1 downto 0);
		o_Value			: OUT	STD_LOGIC);
end component;

begin

int_out(bits+1) <= i_shift_in; -- for shift r
int_out(0) <= i_shift_in; -- for shift l

--  0 load
--  1 shiftl
--  2 shiftr
--  3 clear
sel0 <= i_clear or i_shiftl;
sel1 <= i_shiftr or i_clear;
int_reg_load <= i_load or i_clear or i_shiftr or i_shiftl;

perbitloop: for i in 1 to bits generate
	mux_i: MUX_4_To_1 port map (
		i_0 => i_data(i), i_1 => int_out(i-1), i_2 => int_out(i+1), i_3 => '0', -- load, shift l, shift r, clear
		i_Selector(1) => sel1, i_Selector(0) => sel0,
		o_Value => int_in(i)); 
end generate;

reg_1: reg generic map (bits => bits)
port map (int_in, 
		int_reg_load,
		i_clock,
		int_out(bits downto 1));

o_data <= int_out(bits downto 1); -- don't output extra shift bits at bits+1 and 0

end struct;