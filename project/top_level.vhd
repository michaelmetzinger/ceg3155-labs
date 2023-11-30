library IEEE;
use IEEE.std_logic_1164.all;

entity top_level is
	port(i_gclock, i_greset : in std_logic;
			i_msc, i_ssc : in std_logic_vector(3 downto 0);
			i_sscs : in std_logic;
			o_mstl, o_sstl : out std_logic_vector(2 downto 0); --ryg
			o_bcd1, o_bcd2 : out std_logic_vector(3 downto 0); --left, right diget
			o_lightstate : out std_logic_vector(1 downto 0)
		 );
end top_level;

architecture struct of top_level is
signal int_1hz_clock : std_logic;

signal int_yt : std_logic_vector(3 downto 0); --yellow time
signal int_mux_sel : std_logic_vector(1 downto 0);
signal int_mux_out : std_logic_vector(3 downto 0);

signal int_timer_clock, int_clear_timer : std_logic;
signal int_timer_out : std_logic_vector(3 downto 0);
signal int_not_timer_complete, int_timer_complete : std_logic;
signal int_fsm_clear_timer : std_logic;

signal int_bcd_tens, int_bcd_ones : std_logic_vector(3 downto 0);

signal int_msg, int_msy, int_msr, int_ssg, int_ssy, int_ssr : std_logic; --ms main street, ss second street, (g, y, r) for green yellow red

signal int_car_sensor : std_logic;

signal int_lightstate : std_logic_vector(1 downto 0);

component MUX_4_To_1_n IS
	GENERIC(bits : integer := 2);
	PORT(
		i_0, i_1, i_2, i_3 : IN	STD_LOGIC_VECTOR(bits downto 1);
		i_Selector 		: IN	STD_LOGIC_VECTOR(1 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(bits downto 1));
END component;

component timer is
	port(i_clock, i_clear : in std_logic;
			output : out std_logic_vector(3 downto 0));
end component;

component cmp is
	generic (bits : integer := 2); --must be 2 or greater. use cmp_1 for 1 bit.
	port (i_a, i_b : in std_logic_vector(bits downto 1);
			o_gt, o_eq, o_lt : out std_logic);
end component;

component bcd_encoder is
	port(input : in std_logic_vector(3 downto 0);
			o_tens, o_ones : out std_logic_vector(3 downto 0));
end component;

component fsm_Controller IS
	PORT(
		i_clock									: IN	STD_LOGIC;
		i_reset									: IN	STD_LOGIC;
		i_carSensor, i_timerDone			: IN	STD_LOGIC;
		o_setTimer								: OUT STD_LOGIC;
		o_mGreen, o_mYellow, o_mRed		: OUT	STD_LOGIC;
		o_sGreen, o_sYellow, o_sRed		: OUT	STD_LOGIC;
		o_lightstate : out std_logic_vector(1 downto 0));
end component;

component debouncer IS
	PORT(
		i_raw			: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		o_clean			: OUT	STD_LOGIC);
end component;

component clk_div IS

	PORT
	(
		clock_25Mhz				: IN	STD_LOGIC;
		clock_1MHz				: OUT	STD_LOGIC;
		clock_100KHz				: OUT	STD_LOGIC;
		clock_10KHz				: OUT	STD_LOGIC;
		clock_1KHz				: OUT	STD_LOGIC;
		clock_100Hz				: OUT	STD_LOGIC;
		clock_10Hz				: OUT	STD_LOGIC;
		clock_1Hz				: OUT	STD_LOGIC);
	
END component;

begin
clk_diver: clk_div port map(clock_25Mhz => i_gclock, clock_1MHz => int_1hz_clock);



int_yt <= "1111"; --yellow time 3 clock cycles
int_mux_sel(0) <= int_msg;
int_mux_sel(1) <= int_msg or int_ssg;
mux: MUX_4_To_1_n generic map(bits => 4)
	port map(int_yt, int_yt, i_ssc, i_msc, -- 0 1 2 3
				int_mux_sel,
				int_mux_out);

sscs_debounce: debouncer port map(i_sscs, i_gclock, int_car_sensor);

--int_timer_clock <= i_gclock; --fast clock
int_timer_clock <= int_1hz_clock; -- TODO use for live demo

int_clear_timer <= i_greset or int_fsm_clear_timer;
t: timer port map(int_timer_clock, int_clear_timer, int_timer_out);

comparator: cmp generic map(bits => 4)
	port map(i_a => int_mux_out, i_b => int_timer_out, o_gt => int_not_timer_complete);
int_timer_complete <= not(int_not_timer_complete);

bcd: bcd_encoder port map(int_timer_out, int_bcd_tens, int_bcd_ones);

fsm: fsm_Controller port map(
--	i_gclock, --fast clock
	int_1hz_clock, -- TODO use for live demo slow clock	
	i_greset,
	int_car_sensor, -- car sensor
	int_timer_complete,
	int_fsm_clear_timer,
	int_msg, int_msy, int_msr,
	int_ssg, int_ssy, int_ssr,
	int_lightstate
);

o_lightstate <= int_lightstate;

o_bcd1 <= int_bcd_tens;
o_bcd2 <= int_bcd_ones;

o_mstl(0) <= int_msg;
o_mstl(1) <= int_msy;
o_mstl(2) <= int_msr;
o_sstl(0) <= int_ssg;
o_sstl(1) <= int_ssy;
o_sstl(2) <= int_ssr;
end struct;