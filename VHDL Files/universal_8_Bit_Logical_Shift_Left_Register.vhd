LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY universal_8_Bit_Logical_Shift_Left_Register IS

	PORT(
				--Control Signals--
		i_load, i_shiftLeft, i_shiftRight			: IN	STD_LOGIC;
		
		--Reset Values--
		i_parallelInput									: IN	STD_LOGIC_VECTOR( 7 downto 0);
		
		i_clock												: IN	STD_LOGIC;
		
		o_q, o_qBar											: OUT	STD_LOGIC_VECTOR( 7 downto 0));
		
END universal_8_Bit_Logical_Shift_Left_Register;

ARCHITECTURE Structural of universal_8_Bit_Logical_Shift_Left_Register IS
	SIGNAL int_oq : STD_LOGIC_VECTOR( 7 downto 0);
	SIGNAL int_oqBar : STD_LOGIC_VECTOR( 7 downto 0);
	
	COMPONENT universal_dFF_1 IS
		PORT(
		i_load, i_shiftLeft, i_shiftRight			: IN	STD_LOGIC;
		
		--Inputs from other Registers--
		i_parallelInput									: IN	STD_LOGIC;
		i_shiftLeftInput									: IN	STD_LOGIC;
		i_shiftRightInput									: IN	STD_LOGIC;
		
		i_clock												: IN	STD_LOGIC;
		o_q, o_qBar											: OUT	STD_LOGIC);
	END COMPONENT;
	
BEGIN
 
   
	bit7: universal_dFF_1 port map (i_load, i_shiftLeft, i_shiftRight,i_parallelInput(7), int_oq(6),int_oq(0), i_clock, int_oq(7), int_oqBar(7));
   bit6: universal_dFF_1 port map (i_load, i_shiftLeft, i_shiftRight,i_parallelInput(6), int_oq(5),int_oq(7), i_clock, int_oq(6), int_oqBar(6));
	bit5: universal_dFF_1 port map (i_load, i_shiftLeft, i_shiftRight,i_parallelInput(5), int_oq(4),int_oq(6), i_clock, int_oq(5), int_oqBar(5));
	bit4: universal_dFF_1 port map (i_load, i_shiftLeft, i_shiftRight,i_parallelInput(4), int_oq(3),int_oq(5), i_clock, int_oq(4), int_oqBar(4));
	bit3: universal_dFF_1 port map (i_load, i_shiftLeft, i_shiftRight,i_parallelInput(3), int_oq(2),int_oq(4), i_clock, int_oq(3), int_oqBar(3));
	bit2: universal_dFF_1 port map (i_load, i_shiftLeft, i_shiftRight,i_parallelInput(2), int_oq(1),int_oq(3), i_clock, int_oq(2), int_oqBar(2));
	bit1: universal_dFF_1 port map (i_load, i_shiftLeft, i_shiftRight,i_parallelInput(1), int_oq(0),int_oq(2), i_clock, int_oq(1), int_oqBar(1));
	bit0: universal_dFF_1 port map (i_load, i_shiftLeft, i_shiftRight,i_parallelInput(0), '0',int_oq(1), i_clock, int_oq(0), int_oqBar(0));
	
	o_qBar	 <= int_oqBar;
	o_q <= int_oq;
	
END Structural;


--Create 7 int_oq signals
--Connect each parallel input with corresponding parallel input from the i_parallelInput
--Connect int_oq(i) to the o_q of each register and with each o_q of the 8bit register
--Connect int_oq(i) with the shiftRightInput of flip-flop(i-1) (Goes left to right 7-6-5-4-3-2-1-0)
--Connect int_oq(i) with the shiftLeftInput of flip-flop(i+1) (Goes right to left 7-6-5-4-3-2-1-0)