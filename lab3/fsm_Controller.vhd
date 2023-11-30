LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fsm_Controller IS
	PORT(
		i_clock									: IN	STD_LOGIC;
		i_reset									: IN	STD_LOGIC;
		i_carSensor, i_timerDone			: IN	STD_LOGIC;
		o_setTimer								: OUT STD_LOGIC;
		o_mGreen, o_mYellow, o_mRed		: OUT	STD_LOGIC;
		o_sGreen, o_sYellow, o_sRed		: OUT	STD_LOGIC;
		o_lightstate : out std_logic_vector(1 downto 0));
END fsm_Controller;

ARCHITECTURE struct OF fsm_Controller IS
	SIGNAL int_presentState1, int_presentState0 	: STD_LOGIC;
	SIGNAL int_nextState1, int_nextState0 			: STD_LOGIC;
	SIGNAL int_dInput1, int_dInput0					: STD_LOGIC;

	COMPONENT dFF_2 IS
	PORT(
		i_d			: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		o_q, o_qBar		: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN
	int_nextState1 <= (i_timerDone and not(int_presentState1) and int_presentState0) 
	or (not(i_timerDone) and int_presentState1) 
	or (i_timerDone and int_presentState1 and not(int_presentState0));
	int_nextState0 <= (i_timerDone and i_carSensor and not(int_presentState1) and not(int_presentState0)) 
	or (not(i_timerDone) and int_presentState0) 
	or (i_timerDone and int_presentState1 and not(int_presentState0));
	int_dInput1		<= ((not(i_reset)) and int_nextState1);
	int_dInput0		<= ((not(i_reset)) and int_nextState0);
	
	-- Component Instantiation
	flipFlop1: dFF_2
		PORT MAP (i_d		=> int_dInput1, 
				i_clock 	=> i_clock,
				o_q 		=> int_presentState1,
				o_qBar		=> OPEN);

	flipFlop0: dFF_2
		PORT MAP (i_d		=> int_dInput0, 
				i_clock 	=> i_clock,
				o_q 		=> int_presentState0,
				o_qBar		=> OPEN);
	
	--  Concurrent Signal Assignment
	o_setTimer <= (i_TimerDone and i_carSensor) or (i_timerDone and (not(int_presentState1)) and int_presentState0) or (i_timerDone and int_presentState1);
	
	o_mGreen 	<= ((not(int_presentState1)) and (not(int_presentState0)));
	o_mYellow 	<= ((not(int_presentState1)) and int_presentState0);
	o_mRed 		<=	int_presentState1;
	
	o_sGreen 	<= (int_presentState1 and (not(int_presentState0)));
	o_sYellow 	<= (int_presentState1 and int_presentState0);
	o_sRed 		<= (not(int_presentState1));
	
	o_lightstate(1) <= int_presentState1;
	o_lightstate(0) <= int_presentState0;
	
END struct;