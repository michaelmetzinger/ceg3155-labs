LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX_4_To_1 IS
	PORT(
		i_Value			: IN	STD_LOGIC_VECTOR(3 downto 0);
		i_Selector 		: IN	STD_LOGIC_VECTOR(1 downto 0);
		o_Value			: OUT	STD_LOGIC);
END MUX_4_To_1;

ARCHITECTURE Structural OF MUX_4_To_1 IS
	SIGNAL int_Value1, int_Value0, int_outValue : STD_LOGIC;
	
	COMPONENT MUX_2_TO_1
		PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC;
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC);
	END COMPONENT;
	
BEGIN
	
	M1: MUX_2_TO_1 port map(i_Value(1),i_Value(0),i_Selector(0),int_Value1); 
	M2: MUX_2_TO_1 port map(i_Value(3),i_Value(2),i_Selector(0),int_Value0); 
	M3: MUX_2_TO_1 port map(int_Value0,int_Value1,i_Selector(1),int_outValue); 
	
--  Output Driver
	o_Value		<= int_outValue;
	
END Structural;