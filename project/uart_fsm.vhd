library IEEE;
use IEEE.std_logic_1164.all;

entity uart_fsm is
	port(i_clock, i_reset, i_tx_ready : in std_logic;
		i_light_state : in std_logic_vector(1 downto 0);
		o_transmit_byte : out std_logic;
		o_transmit_data : out std_logic_vector(6 downto 0));
end entity;

architecture struct of uart_fsm is
component MUX_4_To_1_n IS
	GENERIC(bits : integer := 2);
	PORT(
		i_0, i_1, i_2, i_3 : IN	STD_LOGIC_VECTOR(bits downto 1);
		i_Selector 		: IN	STD_LOGIC_VECTOR(1 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(bits downto 1));
END component;
COMPONENT MUX_8_To_1_n IS
	GENERIC(bits : integer := 2);
	PORT(
		i_0,i_1,i_2,i_3,i_4,i_5,i_6,i_7 : IN	STD_LOGIC_VECTOR(bits downto 1);
		i_Selector 		: IN	STD_LOGIC_VECTOR(2 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(bits downto 1));
END COMPONENT;
component counter_4_inc is
	port(i_clock, i_clear, i_inc : in std_logic;
			output : out std_logic_vector(3 downto 0));
end component;
component uart_fsm_ctrl is
	port(i_clock, i_reset,
		  i_state_change, i_word_sent, i_tx_ready : in std_logic;
		  o_inc_ctr, o_clear_ctr, o_transmit_byte : out std_logic
		  );
end component;
component dFF_2 IS
	PORT(
		i_d		: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END component;

signal int_mux0_out, int_mux1_out, int_data_out : std_logic_vector(6 downto 0);
signal int_clear_ctr, int_inc_ctr : std_logic;
signal int_counter : std_logic_vector(3 downto 0);
signal int_state_change, int_word_sent : std_logic;
signal int_old_light_state : std_logic_vector(1 downto 0);
signal int_transmit_byte : std_logic;

begin

--data out
mux0: MUX_4_To_1_n generic map (bits => 7)
	port map("1100111", "1111001", "1110010", "1110010", --gyrr
	i_light_state,
	int_mux0_out
);
mux1: MUX_4_To_1_n generic map (bits => 7)
	port map("1110010", "1110010","1100111", "1111001", --rrgy
	i_light_state,
	int_mux1_out
);

mux2: MUX_8_To_1_n generic map (bits => 7)
	port map("1001101", int_mux0_out, "0101101", "1010011", int_mux1_out, 
			   "0001010", "0000000", "0000000", --M(int_mux0)-S(int_mux1)\n\0\0
				int_counter(2 downto 0),
				int_data_out
);
--end data out

-- character tracker
ctr: counter_4_inc port map(i_clock, int_clear_ctr, int_inc_ctr, int_counter);
int_word_sent <= int_counter(2) and int_counter(1) and not(int_counter(0)); --counter == 6
-- end character tracker

ctrl: uart_fsm_ctrl port map(i_clock, i_reset,
		  int_state_change, int_word_sent, i_tx_ready,
		  int_inc_ctr, int_clear_ctr, int_transmit_byte);

--state change detection
lightstate1: dFF_2 port map(i_d => i_light_state(1), i_clock => i_clock, o_q => int_old_light_state(1));
lightstate0: dFF_2 port map(i_d => i_light_state(0), i_clock => i_clock, o_q => int_old_light_state(0));
int_state_change <= (i_light_state(1) xor int_old_light_state(1)) or (i_light_state(0) xor int_old_light_state(0));
--end state change detection

o_transmit_byte <= int_transmit_byte;
o_transmit_data <= int_data_out;
end struct;