LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX_2_To_1 IS
	PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC;
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC);
END MUX_2_To_1;


ARCHITECTURE Structural OF MUX_2_To_1 IS
	SIGNAL int_Value1, int_Value0 : STD_LOGIC;
	
BEGIN
	int_Value1<= i_Selector and i_Value1;
	int_Value0<= not(i_Selector) and i_Value0;
	
--  Output Driver
	o_Value		<= int_Value1 or int_Value0 ;
	
END Structural;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX_2_To_1_n IS
	GENERIC(bits : integer := 2);
	PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC_VECTOR(bits downto 1);
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC_VECTOR(bits downto 1));
END MUX_2_To_1_n;

ARCHITECTURE Structural OF MUX_2_To_1_n IS
SIGNAL int_out : STD_LOGIC_VECTOR(bits downto 1);

COMPONENT MUX_2_To_1 IS
	PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC;
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC);
END COMPONENT;

BEGIN
muxloop: FOR i IN 1 TO bits GENERATE
	mux_i: MUX_2_To_1 PORT MAP (i_Value1(i), i_Value0(i), i_Selector, int_out(i));
END GENERATE;

o_Value <= int_out;
END Structural;
