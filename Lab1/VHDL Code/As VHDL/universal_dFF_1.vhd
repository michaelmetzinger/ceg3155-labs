LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY universal_dFF_1 IS
	PORT(
				--Control Signals--
		i_load, i_shiftLeft, i_shiftRight			: IN	STD_LOGIC;
		
		--Inputs from other Registers--
		i_parallelInput									: IN	STD_LOGIC;
		i_shiftLeftInput									: IN	STD_LOGIC;
		i_shiftRightInput									: IN	STD_LOGIC;
		
		i_clock												: IN	STD_LOGIC;
		o_q, o_qBar											: OUT	STD_LOGIC);
END universal_dFF_1;

ARCHITECTURE rtl OF universal_dFF_1 IS
	SIGNAL int_dInput: STD_LOGIC;
	SIGNAL int_q, int_qBar: STD_LOGIC;
	
	SIGNAL int_s0 : STD_LOGIC;
	SIGNAL int_s1 : STD_LOGIC;
--	
--	SIGNAL int_loadLine: STD_LOGIC;
--	SIGNAL int_shiftLeftLine: STD_LOGIC;
--	SIGNAL int_shiftRightLine: STD_LOGIC;
--	SIGNAL int_latchLine: STD_LOGIC;

	COMPONENT dFF_1
	PORT(
		i_d			: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		o_q, o_qBar		: OUT	STD_LOGIC);
	END COMPONENT;
	
	COMPONENT MUX_4_To_1
	PORT(
		i_Value			: IN	STD_LOGIC_VECTOR(3 downto 0);
		i_Selector 		: IN	STD_LOGIC_VECTOR(1 downto 0);
		o_Value			: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

	-- Component Instantiation
	
		control_MUX: MUX_4_To_1
		PORT MAP ( 
				i_Selector(0) => int_s0,
				i_Selector(1) => int_s1, 
				
				i_Value(3) => i_parallelInput,
				i_Value(2) => i_shiftRightInput,
				i_Value(1) => i_shiftLeftInput,
				i_Value(0) => int_q,
		
		
				o_Value => int_dInput);
	
	storing_dFF: dFF_1
		PORT MAP ( i_d 		=> int_dInput, 
				i_clock		=> i_clock,
				o_q 			=> int_q,
				o_qBar		=> int_qBar);
				

	
	--  Concurrent Signal Assignment
	int_s0 <= (i_load or i_shiftLeft);
	int_s1 <= (i_load or i_shiftRight);
	
	o_q <= int_q;
	o_qBar <= int_qBar;
	
END rtl;
