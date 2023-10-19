LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity Nick_MUX_8_To_4 is
	port(i_1, i_0 : in STD_LOGIC_VECTOR(3 downto 0);
			i_Selector 		: IN	STD_LOGIC ;	
			o : out STD_LOGIC_VECTOR(3 downto 0));
end Nick_MUX_8_To_4;

ARCHITECTURE struct of Nick_MUX_8_To_4 is
	SIGNAL int : STD_LOGIC_VECTOR(3 downto 0);
	
COMPONENT Nick_MUX_2_To_1
	PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC;
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC);
END COMPONENT;

BEGIN	
b3: Nick_MUX_2_To_1
	port map (
		i_Selector 	=> i_Selector,
		i_Value1 	=> i_1(3),
		i_Value0 	=> i_0(3),
		o_Value 		=> int(3));
	
b2: Nick_MUX_2_To_1
	port map (
		i_Selector 	=> i_Selector,
		i_Value1 	=> i_1(2),
		i_Value0 	=> i_0(2),
		o_Value 		=> int(2));
	
b1: Nick_MUX_2_To_1
	port map (
		i_Selector 	=> i_Selector,
		i_Value1 	=> i_1(1),
		i_Value0 	=> i_0(1),
		o_Value 		=> int(1));
	
b0: Nick_MUX_2_To_1
	port map (
		i_Selector 	=> i_Selector,
		i_Value1 	=> i_1(0),
		i_Value0 	=> i_0(0),
		o_Value 		=> int(0));

	o <= int;

end struct;