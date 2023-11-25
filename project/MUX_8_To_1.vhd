LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX_8_To_1 IS
	PORT(
		i_0,i_1,i_2,i_3,i_4,i_5,i_6,i_7 : IN	STD_LOGIC;
		i_Selector : IN	STD_LOGIC_VECTOR(2 downto 0);
		o_Value : OUT	STD_LOGIC);
END MUX_8_To_1;

ARCHITECTURE Structural OF MUX_8_To_1 IS
	SIGNAL int_Value1, int_Value0, int_outValue : STD_LOGIC;
	
	COMPONENT MUX_2_TO_1
		PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC;
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC);
	END COMPONENT;
	
	component MUX_4_To_1 IS
		PORT(
			i_0, i_1,i_2,i_3			: IN	STD_LOGIC;
			i_Selector 		: IN	STD_LOGIC_VECTOR(1 downto 0);
			o_Value			: OUT	STD_LOGIC);
	END component;
	
BEGIN
	
	M1: MUX_4_TO_1 port map(i_0,i_1,i_2,i_3,i_Selector(1 downto 0),int_Value0); 
	M2: MUX_4_TO_1 port map(i_4,i_5,i_6,i_7,i_Selector(1 downto 0),int_Value1); 
	M3: MUX_2_TO_1 port map(int_Value1,int_Value0,i_Selector(2),int_outValue); 
	
--  Output Driver
	o_Value		<= int_outValue;
	
END Structural;


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX_8_To_1_n IS
	GENERIC(bits : integer := 2);
	PORT(
		i_0,i_1,i_2,i_3,i_4,i_5,i_6,i_7 : IN	STD_LOGIC_VECTOR(bits downto 1);
		i_Selector 		: IN	STD_LOGIC_VECTOR(2 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(bits downto 1));
END MUX_8_To_1_n;

ARCHITECTURE struct OF MUX_8_To_1_n IS
SIGNAL int_out : STD_LOGIC_VECTOR(bits downto 1);
COMPONENT MUX_8_To_1 IS
	PORT(
		i_0,i_1,i_2,i_3,i_4,i_5,i_6,i_7 : IN	STD_LOGIC;
		i_Selector : IN	STD_LOGIC_VECTOR(2 downto 0);
		o_Value : OUT	STD_LOGIC);
END COMPONENT;
BEGIN

muxloop: FOR i IN 1 TO bits GENERATE
	mux_i: MUX_8_To_1 port map (
		i_0(i),i_1(i),i_2(i),i_3(i),i_4(i),i_5(i),i_6(i),i_7(i),
		i_Selector,
		int_out(i));
END GENERATE;

o_Value <= int_out;
END struct;
