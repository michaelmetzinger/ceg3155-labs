LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Nick_MUX_2_To_1 IS
	PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC;
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC);
END Nick_MUX_2_To_1;


ARCHITECTURE Structural OF Nick_MUX_2_To_1 IS
	SIGNAL int_Value1, int_Value0 : STD_LOGIC;
	
BEGIN
	int_Value1<= i_Selector and i_Value1;
	int_Value0<= not(i_Selector) and i_Value0;
	
--  Output Driver
	o_Value		<= int_Value1 or int_Value0 ;
	
END Structural;