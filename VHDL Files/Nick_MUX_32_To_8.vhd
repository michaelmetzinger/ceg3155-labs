LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity Nick_MUX_32_To_8 is
	port(i_3, i_2, i_1, i_0 : in STD_LOGIC_VECTOR(7 downto 0);
			i_Selector 		: IN	STD_LOGIC_VECTOR(1 downto 0);		
			o : out STD_LOGIC_VECTOR(7 downto 0));
end Nick_MUX_32_To_8;

ARCHITECTURE struct of Nick_MUX_32_To_8 is
	SIGNAL int : STD_LOGIC_VECTOR(7 downto 0);
	
COMPONENT Nick_MUX_4_To_1
	PORT
		(i_Value			: IN	STD_LOGIC_VECTOR(3 downto 0);
		i_Selector 		: IN	STD_LOGIC_VECTOR(1 downto 0);
		o_Value			: OUT	STD_LOGIC);
END COMPONENT;

BEGIN

b7: Nick_MUX_4_To_1
	port map (
		i_Selector(1) => i_Selector(1),
		i_Selector(0) => i_Selector(0),
		i_Value(3) => i_3(7),
		i_Value(2) => i_2(7),
		i_Value(1) => i_1(7),
		i_Value(0) => i_0(7),
		o_Value => int(7));
	
b6: Nick_MUX_4_To_1
	port map (
		i_Selector(1) => i_Selector(1),
		i_Selector(0) => i_Selector(0),
		i_Value(3) => i_3(6),
		i_Value(2) => i_2(6),
		i_Value(1) => i_1(6),
		i_Value(0) => i_0(6),
		o_Value => int(6));

b5: Nick_MUX_4_To_1
	port map (
		i_Selector(1) => i_Selector(1),
		i_Selector(0) => i_Selector(0),
		i_Value(3) => i_3(5),
		i_Value(2) => i_2(5),
		i_Value(1) => i_1(5),
		i_Value(0) => i_0(5),
		o_Value => int(5));

b4: Nick_MUX_4_To_1
	port map (
		i_Selector(1) => i_Selector(1),
		i_Selector(0) => i_Selector(0),
		i_Value(3) => i_3(4),
		i_Value(2) => i_2(4),
		i_Value(1) => i_1(4),
		i_Value(0) => i_0(4),
		o_Value => int(4));
	
b3: Nick_MUX_4_To_1
	port map (
		i_Selector(1) => i_Selector(1),
		i_Selector(0) => i_Selector(0),
		i_Value(3) => i_3(3),
		i_Value(2) => i_2(3),
		i_Value(1) => i_1(3),
		i_Value(0) => i_0(3),
		o_Value => int(3));
	
b2: Nick_MUX_4_To_1
	port map (
		i_Selector(1) => i_Selector(1),
		i_Selector(0) => i_Selector(0),
		i_Value(3) => i_3(2),
		i_Value(2) => i_2(2),
		i_Value(1) => i_1(2),
		i_Value(0) => i_0(2),
		o_Value => int(2));
	
b1: Nick_MUX_4_To_1
	port map (
		i_Selector(1) => i_Selector(1),
		i_Selector(0) => i_Selector(0),
		i_Value(3) => i_3(1),
		i_Value(2) => i_2(1),
		i_Value(1) => i_1(1),
		i_Value(0) => i_0(1),
		o_Value => int(1));
	
b0: Nick_MUX_4_To_1
	port map (
		i_Selector(1) => i_Selector(1),
		i_Selector(0) => i_Selector(0),
		i_Value(3) => i_3(0),
		i_Value(2) => i_2(0),
		i_Value(1) => i_1(0),
		i_Value(0) => i_0(0),
		o_Value => int(0));

	o <= int;

end struct;