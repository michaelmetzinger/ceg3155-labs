LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY load_dFF_1 IS
	PORT(
		i_load	:IN STD_LOGIC;
		
		i_parallelInput :IN STD_LOGIC;
		
		i_clock			: IN	STD_LOGIC;
		o_q, o_qBar		: OUT	STD_LOGIC);
END load_dFF_1;

ARCHITECTURE rtl OF load_dFF_1 IS
	SIGNAL int_dInput: STD_LOGIC;
	SIGNAL int_q, int_qBar: STD_LOGIC;
--	
--	SIGNAL int_loadLine: STD_LOGIC;
--	SIGNAL int_shiftLeftLine: STD_LOGIC;
--	SIGNAL int_shiftRightLine: STD_LOGIC;
--	SIGNAL int_latchLine: STD_LOGIC;

	COMPONENT dFF_1
	PORT(
		i_d				: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		o_q, o_qBar		: OUT	STD_LOGIC);
	END COMPONENT;
	
	COMPONENT Nick_MUX_2_To_1
	PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC;
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

	-- Component Instantiation
	
		control_MUX: Nick_MUX_2_To_1
		PORT MAP ( 
				i_Value1 => i_parallelInput,
				i_Value0 => int_q,
				i_Selector => i_load,
		
				o_Value => int_dInput);
	
	storing_dFF: dFF_1
		PORT MAP ( i_d 		=> int_dInput, 
				i_clock		=> i_clock,
				o_q 			=> int_q,
				o_qBar		=> int_qBar);
				

	
	--  Concurrent Signal Assignment

	
	o_q <= int_q;
	o_qBar <= int_qBar;
	
END rtl;