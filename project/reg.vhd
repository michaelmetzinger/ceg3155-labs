library IEEE;
use IEEE.std_logic_1164.all;

entity reg is
	generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_load : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end reg;

architecture struct of reg is
signal int_in, int_out : std_logic_vector(bits downto 1);

component dFF_2 IS
	PORT(
		i_d		: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
end component;
component MUX_2_To_1 IS
	PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC;
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC);
end component;

begin

perbitloop: for i in 1 to bits generate
	mux_i: MUX_2_To_1 port map(i_data(i), int_out(i), i_load, int_in(i));
	dFF_i: dFF_2 port map(i_d => int_in(i), i_clock => i_clock, o_q => int_out(i));
end generate;

o_data <= int_out;

end struct;