library IEEE;
use IEEE.std_logic_1164.all;

entity transmitter_top_level is
	port ( i_reset: in std_logic;
			 i_clock: in std_logic;
			 i_data: in std_logic_vector(6 downto 0);
			 i_transmitByte: in std_logic;
			 o_Tx_Busy: out std_logic;
			 o_TxData: out std_logic);
end transmitter_top_level;

architecture struct of transmitter_top_level is

signal int_loadTDR : std_logic;
signal int_TDR_Output: std_logic_vector(6 downto 0);

signal int_loadTSR : std_logic;
signal int_shiftTSR : std_logic;
signal int_TSR_Input :std_logic_vector(8 downto 0);
signal int_TSR_Output: std_logic_vector (8 downto 0);

signal int_parityBit: std_logic;
signal int_TX_SerialData: std_logic;

signal int_TX_Enable: std_logic;
signal int_TX_Busy: std_logic;

signal int_setCounter: std_logic;
signal int_countDone: std_logic;
signal int_counter_Output: std_logic_vector(3 downto 0);
signal int_numShifts: std_logic_vector (3 downto 0):= "1000";

signal int_countNotDone: std_logic;

COMPONENT MUX_2_To_1 IS
	PORT(
		i_Value1, i_Value0	: IN	STD_LOGIC;
		i_Selector 				: IN	STD_LOGIC;
		o_Value					: OUT	STD_LOGIC);
END COMPONENT;

component reg is
	generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_load : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end component;

component reg_load_shiftr is
	generic (bits : integer := 4);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_shift_in : in std_logic;
			i_load, i_shiftr : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end component;

component parity_generator is
	port(
		i_input : in std_logic_vector(6 downto 0);
		o_evenParity: out std_logic;
		o_oddParity : out std_logic);
end component;

component timer is
	port(i_clock, i_clear : in std_logic;
			output : out std_logic_vector(3 downto 0));
end component;

component cmp is
	generic (bits : integer := 2); --must be 2 or greater. use cmp_1 for 1 bit.
	port (i_a, i_b : in std_logic_vector(bits downto 1);
			o_gt, o_eq, o_lt : out std_logic);
end component;

component transmitter_controller is
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
end component;

begin

int_TSR_Input <= (int_parityBit & int_TDR_Output & '0');

TDR: reg generic map(bits => 7)
	port map(i_data, int_loadTDR, i_clock, int_TDR_Output);
	
myParityGenerator: parity_generator port map (int_TDR_Output,int_parityBit, OPEN);

TSR: reg_load_shiftr generic map(bits => 9)
	port map (int_TSR_Input, '0', int_loadTSR, int_shiftTSR, i_clock, int_TSR_Output);
	
Mux: MUX_2_To_1 port map (int_TSR_Output(0), '1', int_TX_Enable, int_TX_SerialData);

Counter : timer port map(i_clock, int_setCounter, int_counter_Output);

Comparator: cmp generic map(bits => 4)
	port map (int_numShifts, int_counter_Output, int_countNotDone, OPEN, OPEN);
int_countDone <= not(int_countNotDone);

myController: transmitter_controller port map(
						i_reset, 
						i_clock, 
						i_transmitByte, 
						int_countDone, 
						int_setCounter, 
						int_loadTDR,
						int_loadTSR,
						int_shiftTSR,
						int_TX_Enable,
						int_TX_Busy);

o_Tx_Busy <= int_TX_Busy;
o_TxData <= int_TX_SerialData;
	
end struct;