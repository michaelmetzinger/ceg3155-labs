LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY LED_Display IS
	PORT(
	i_leftButton 				: IN	STD_LOGIC;	
	i_rightButton 				: IN	STD_LOGIC;
	i_GResetButton  			: IN	STD_LOGIC;
	i_clock						: IN	STD_LOGIC;
	
	o_display					: OUT STD_LOGIC_VECTOR(7 downto 0));

END LED_Display;

ARCHITECTURE struct of LED_Display is
	SIGNAL int_load 				: STD_LOGIC;
	SIGNAL int_rshift				: STD_LOGIC;
	SIGNAL int_display_sel_1	: STD_LOGIC;
	SIGNAL int_lshift  			: STD_LOGIC;
	SIGNAL int_display_sel_0 	: STD_LOGIC;
	
	SIGNAL int_Display 			: STD_LOGIC_VECTOR(7 downto 0);
	
	
	COMPONENT dataPath
		PORT(
				i_load 				: IN	STD_LOGIC;	
				i_rshift 			: IN	STD_LOGIC;
				i_display_sel_1  	: IN	STD_LOGIC;
				i_lshift  			: IN	STD_LOGIC;
				i_display_sel_0 	: IN	STD_LOGIC;
				i_clock				: IN  STD_LOGIC;
				
				o_display			: OUT STD_LOGIC_VECTOR(7 downto 0));
	END COMPONENT;
	
	COMPONENT control
		PORT(
				i_greset, i_left, i_right 	: IN	STD_LOGIC;	
				i_clock 							: IN	STD_LOGIC;	
				
				o_load, o_rshift, o_lshift, o_display_sel_1, o_display_sel_0 : out std_logic);
	END COMPONENT;
	
BEGIN

	controlPath	: control 	port map (i_GResetButton, i_leftButton, i_rightButton, i_clock, int_load, int_rshift, int_lshift, int_display_sel_1, int_display_sel_0);
	myDataPath		: dataPath 	port map	(int_load, int_rshift, int_display_sel_1, int_lshift, int_display_sel_0, i_clock, int_Display);
	
	o_display <= int_Display;
	
END struct;
	