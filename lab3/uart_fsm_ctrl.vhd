library IEEE;
use IEEE.std_logic_1164.all;

entity uart_fsm_ctrl is
	port(i_clock, i_reset,
		  i_state_change, i_word_sent, i_tx_ready : in std_logic;
		  o_inc_ctr, o_clear_ctr, o_transmit_byte : out std_logic
		  );
end entity;


architecture struct of uart_fsm_ctrl is

component dFF_2 IS
	PORT(
		i_d		: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END component;

signal int_a_cond, int_b_cond, int_c_cond : std_logic;
signal int_a, int_b, int_c : std_logic;

begin

a_dff: dFF_2 port map(i_d => int_a_cond, i_clock => i_clock, o_q => int_a);
b_dff: dFF_2 port map(i_d => int_b_cond, i_clock => i_clock, o_q => int_b);
c_dff: dFF_2 port map(i_d => int_c_cond, i_clock => i_clock, o_q => int_c);


int_a_cond <= not(i_reset) and ((int_a and not(i_state_change)) or (int_b and i_word_sent));
int_b_cond <= i_reset or ((int_a and i_state_change) or int_c or (int_b and not(i_word_sent) and not(i_tx_ready)));
int_c_cond <= not(i_reset) and 
				  (int_b and i_tx_ready and not(i_word_sent));

o_inc_ctr <= int_c;
o_clear_ctr <= int_a or i_reset;
o_transmit_byte <= int_c;
end struct;
