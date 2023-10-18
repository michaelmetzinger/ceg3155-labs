library IEEE;
use IEEE.std_logic_1164.all;

entity reg_clear is
	generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_load, i_clear : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end reg_clear;

architecture struct of reg_clear is
signal int_in, int_out : std_logic_vector(bits downto 1);
signal int_load_clear : std_logic;

component reg is
	generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_load : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end component;
component MUX_2_To_1 IS
	PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC;
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC);
end component;

begin

int_load_clear <= i_load or i_clear;

perbitloop: for i in 1 to bits generate
	mux_i: MUX_2_To_1 port map('0', i_data(i), i_clear, int_in(i));
end generate;

reg1: reg generic map (bits => bits)
	port map(int_in, int_load_clear, i_clock, int_out);

o_data <= int_out;

end struct;