library IEEE;
use IEEE.std_logic_1164.all;

entity transmitter_controller is
	port ( i_reset : in std_logic;
			 i_clock : in std_logic;
			 i_transmitByte : in std_logic;
			 i_countDone	: in std_logic;
			 o_setCounter : out std_logic;
			 o_loadTDR : out std_logic;
			 o_loadTSR: out std_logic;
			 o_shiftTSR: out std_logic;
			 o_enableTransmission: out std_logic;
			 o_Tx_Busy: out std_logic);
end transmitter_controller;

architecture struct of transmitter_controller is
signal int_nextState0, int_nextState1,int_nextState2, int_nextState3: std_logic;
signal int_presentState0, int_presentState1,int_presentState2, int_presentState3: std_logic;

component dFF_2 IS
	PORT(
		i_d		: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
end component;

begin

	int_NextState0 <= i_reset or (int_presentState0 and (not(i_transmitByte))) or (int_presentState3 and i_countDone);
	int_NextState1 <= (int_presentState0 and i_transmitByte and not(i_reset));
	int_NextState2 <= (int_presentState1 and not(i_reset));
	int_NextState3 <=(int_presentState2 and not(i_reset)) or (int_presentState3 and not(i_reset) and not(i_countDone));
	
	
	myDFF0: dFF_2 port map(int_nextState0, i_clock, int_presentState0, OPEN);
	myDFF1: dFF_2 port map(int_nextState1, i_clock, int_presentState1, OPEN);
	myDFF2: dFF_2 port map(int_nextState2, i_clock, int_presentState2, OPEN);
	myDFF3: dFF_2 port map(int_nextState3, i_clock, int_presentState3, OPEN);
	
	o_setCounter <= int_presentState2;
	o_loadTDR <= int_presentState1;
	o_loadTSR <= int_presentState2;
	o_shiftTSR <= int_presentState3;
	o_enableTransmission <= int_presentState3;
	o_Tx_Busy <= int_presentState1 or int_presentState2 or int_presentState3;

end struct;