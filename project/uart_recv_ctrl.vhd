library IEEE;
use IEEE.std_logic_1164.all;

--Potential changes FE recovery state(wait for a 1)
--i_RIE clears OE right away (FE too?), 

entity uart_recv_ctrl  is
	port(
		--inputs
		i_RxD, i_RIE, i_clock, i_reset,
		i_timer_done, i_RDRF_data_out : in std_logic;
		--outputs
		o_load_RDR, o_shift_RSR, o_load_FE, o_load_OE, o_load_RDRF, o_counter_clear,
		o_FE_data_in, o_OE_data_in, o_RDRF_data_in : out std_logic;
		o_endcount : out std_logic_vector(3 downto 0)
	);
end uart_recv_ctrl;

architecture struct of uart_recv_ctrl is

component dFF_2 IS
	PORT(
		i_d		: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END component;

signal int_idle_cond, int_idle : std_logic;
signal int_start_cond, int_start : std_logic;
signal int_1_cond, int_1 : std_logic;
signal int_2_cond, int_2 : std_logic;
signal int_3_cond, int_3 : std_logic;
signal int_4_cond, int_4 : std_logic;
signal int_5_cond, int_5 : std_logic;
signal int_6_cond, int_6 : std_logic;
signal int_7_cond, int_7 : std_logic;
signal int_parity_cond, int_parity : std_logic;
signal int_stop_cond, int_stop : std_logic;

signal int_w : std_logic; -- signals to go to next state

begin
--one hot dff's
idle_dff: dFF_2 port map(i_d => int_idle_cond, i_clock => i_clock, o_q => int_idle);
start_dff: dFF_2 port map(i_d => int_start_cond, i_clock => i_clock, o_q => int_start);
dff1: dFF_2 port map(i_d => int_1_cond, i_clock => i_clock, o_q => int_1);
dff2: dFF_2 port map(i_d => int_2_cond, i_clock => i_clock, o_q => int_2);
dff3: dFF_2 port map(i_d => int_3_cond, i_clock => i_clock, o_q => int_3);
dff4: dFF_2 port map(i_d => int_4_cond, i_clock => i_clock, o_q => int_4);
dff5: dFF_2 port map(i_d => int_5_cond, i_clock => i_clock, o_q => int_5);
dff6: dFF_2 port map(i_d => int_6_cond, i_clock => i_clock, o_q => int_6);
dff7: dFF_2 port map(i_d => int_7_cond, i_clock => i_clock, o_q => int_7);
parity_dff: dFF_2 port map(i_d => int_parity_cond, i_clock => i_clock, o_q => int_parity);
stop_dff: dFF_2 port map(i_d => int_stop_cond, i_clock => i_clock, o_q => int_stop);

int_w <= (int_idle and not(i_RxD)) or (not(int_idle) and i_timer_done);

int_idle_cond <= i_reset or (int_idle and not(int_w)) or (int_stop and int_w);
int_start_cond <= ((int_start and not(int_w)) or (int_idle and int_w)) and not(i_reset);
int_1_cond <= ((int_1 and not(int_w)) or (int_start and int_w)) and not(i_reset);
int_2_cond <= ((int_2 and not(int_w)) or (int_1 and int_w)) and not(i_reset);
int_3_cond <= ((int_3 and not(int_w)) or (int_2 and int_w)) and not(i_reset);
int_4_cond <= ((int_4 and not(int_w)) or (int_3 and int_w)) and not(i_reset);
int_5_cond <= ((int_5 and not(int_w)) or (int_4 and int_w)) and not(i_reset);
int_6_cond <= ((int_6 and not(int_w)) or (int_5 and int_w)) and not(i_reset);
int_7_cond <= ((int_7 and not(int_w)) or (int_6 and int_w)) and not(i_reset);
int_parity_cond <= ((int_parity and not(int_w)) or (int_7 and int_w)) and not(i_reset);
int_stop_cond <= ((int_stop and not(int_w)) or (int_parity and int_w)) and not(i_reset);

o_load_RDR <= (int_stop and int_w) or i_reset;
o_shift_RSR <= (int_1 or int_2 or int_3 or int_4 or int_5 or int_6 or int_7) and int_w;

o_counter_clear <= int_w;

o_load_FE <= (int_stop and int_w) or i_reset;
o_FE_data_in <= not(i_RxD) and not(i_reset); -- not a stop bit

o_load_OE <= (int_stop and int_w) or i_reset;
o_OE_data_in <= i_RDRF_data_out and not(i_reset); -- RDR not consumed

o_load_RDRF <= (int_stop and int_w) or i_RIE or i_reset;
o_RDRF_data_in <= int_stop and int_w and not(i_reset);

o_endcount(3) <= '0';
o_endcount(2) <= not(int_idle or int_start);
o_endcount(1) <= not(int_idle);
o_endcount(0) <= not(int_idle);
end struct;