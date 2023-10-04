LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dataPath IS
	PORT(
	i_load 				: IN	STD_LOGIC;	
	i_rshift 			: IN	STD_LOGIC;
	i_display_sel_1  	: IN	STD_LOGIC;
	i_lshift  			: IN	STD_LOGIC;
	i_display_sel_0 	: IN	STD_LOGIC;
	i_clock				: IN  STD_LOGIC;
	
	o_display			: OUT STD_LOGIC_VECTOR(7 downto 0));

END dataPath;
	
ARCHITECTURE Structural OF dataPath IS
	SIGNAL int_RMask 		: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL int_LMask 		: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL int_OR 			: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL int_MUX 		: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL int_Display 	: STD_LOGIC_VECTOR(7 downto 0);
	
	COMPONENT universal_8_bit_register is
		PORT(
			i_load, i_shiftLeft, i_shiftRight		: IN	STD_LOGIC;
			i_parallelInput								: IN	STD_LOGIC_VECTOR( 7 downto 0);
			i_clock											: IN	STD_LOGIC;
			o_q, o_qBar										: OUT	STD_LOGIC_VECTOR( 7 downto 0));
	END COMPONENT;
	
	COMPONENT or8x2 is
		PORT(
			i_a, i_b 	: in std_logic_vector(7 downto 0);
			o 				: out std_logic_vector(7 downto 0));
	END COMPONENT;
	
	COMPONENT MUX_32_To_8 is
		PORT(
			i_3, i_2, i_1, i_0 : in STD_LOGIC_VECTOR(7 downto 0);
			i_Selector 				: IN	STD_LOGIC_VECTOR(1 downto 0);		
			o 							: out STD_LOGIC_VECTOR(7 downto 0));
	END COMPONENT;
	
	COMPONENT Register_8_Bit is
		PORT(
		i_parallelInput			: IN	STD_LOGIC_VECTOR (7 downto 0);
		i_clock						: IN	STD_LOGIC;
		o_q, o_qBar					: OUT	STD_LOGIC_VECTOR (7 downto 0));
	END COMPONENT;
	
BEGIN

	RMASK		: universal_8_Bit_Register port map (i_load, '0', i_rshift, "10000000", i_clock, int_RMask);
	LMASK		: universal_8_Bit_Register port map (i_load, i_lshift, '0', "00000001", i_clock, int_LMask);
	OR_Gate	: or8x2						port map (int_RMask, int_LMask, int_OR);
	MUX		: MUX_32_To_8					port map	(int_OR, int_RMask, int_LMask, "00000000",(i_display_sel_1, i_display_sel_0), int_MUX);
	Display	: Register_8_Bit				port map (int_MUX, i_clock, int_Display);
	
	o_display <=int_Display;
	
END Structural;
