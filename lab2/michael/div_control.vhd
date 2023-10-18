library IEEE;
use IEEE.std_logic_1164.all;

entity div_control is
	port (
		i_clock,
		i_reset,
		i_gt,
		i_neg,
		i_neg_a, i_neg_b : in std_logic;
		
		o_r_load, o_r_sel, 
		o_d_sel, o_d_load, o_d_shiftr, 
		o_q_shift_in, o_q_load, o_q_clear, o_q_shiftl,
		o_add_left_sel	: out std_logic;
		o_add_right_sel : out std_logic_vector(1 downto 0);
		o_addbar_sub,
		o_neg_load, o_neg_clear,
		o_output_load : out std_logic
	);
end div_control;

architecture struct of div_control is
signal int_state_cond : std_logic_vector(18 downto 0);
signal int_state_out : std_logic_vector(18 downto 0);
signal int_s1_s2, int_s3_s4, int_s5_s6, int_s7_s8, int_s9_s10, int_s11_s12 : std_logic;
signal int_divs, int_not_divs : std_logic;

component dFF_2 IS
	PORT(
		i_d		: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END component;

begin

dff_state_gen: for i in 0 to 18 generate
	dff_i: dFF_2 port map(i_d => int_state_cond(i), i_clock => i_clock, o_q => int_state_out(i));
end generate;

int_s1_s2 <= int_state_out(1) or int_state_out(2);
int_s3_s4 <= int_state_out(3) or int_state_out(4);
int_s5_s6 <= int_state_out(5) or int_state_out(6);
int_s7_s8 <= int_state_out(7) or int_state_out(8);
int_s9_s10 <= int_state_out(9) or int_state_out(10);
int_s11_s12 <= int_state_out(11) or int_state_out(12);

--when a 1 is appended to q
int_divs <= int_state_out(5) or int_state_out(7) or int_state_out(9) or int_state_out(11);
--when a 0 is appended to q
int_not_divs <= int_state_out(6) or int_state_out(8) or int_state_out(10) or int_state_out(12);

int_state_cond(0) <= i_reset or int_state_out(14);
int_state_cond(1) <= not(i_reset) and (int_state_out(0) and i_neg_a); 
int_state_cond(2) <= not(i_reset) and (int_state_out(0) and not(i_neg_a)); 
int_state_cond(3) <= not(i_reset) and (int_s1_s2 and i_neg_b); 
int_state_cond(4) <= not(i_reset) and (int_s1_s2 and not(i_neg_b)); 
int_state_cond(5) <= not(i_reset) and (int_state_out(15) and not(i_gt)); 
int_state_cond(6) <= not(i_reset) and (int_state_out(15) and i_gt); 
int_state_cond(7) <= not(i_reset) and (int_state_out(16) and not(i_gt)); 
int_state_cond(8) <= not(i_reset) and (int_state_out(16) and i_gt); 
int_state_cond(9) <= not(i_reset) and (int_state_out(17) and not(i_gt)); 
int_state_cond(10) <= not(i_reset) and (int_state_out(17) and i_gt); 
int_state_cond(11) <= not(i_reset) and (int_state_out(18) and not(i_gt)); 
int_state_cond(12) <= not(i_reset) and (int_state_out(18) and i_gt); 
int_state_cond(13) <= not(i_reset) and (int_s11_s12 and i_neg); 
int_state_cond(14) <= not(i_reset) and ((int_s11_s12 and not(i_neg)) or int_state_out(13));

--states 15 to 18 are buffer states that where added afterwords to add a clock cycle to allow for the register lag to check the gt signal 
int_state_cond(15) <= not(i_reset) and int_s3_s4;
int_state_cond(16) <= not(i_reset) and int_s5_s6;
int_state_cond(17) <= not(i_reset) and int_s7_s8;
int_state_cond(18) <= not(i_reset) and int_s9_s10;


o_r_load <= int_s1_s2 or int_divs;
o_r_sel <= int_state_out(1) or int_divs; 

o_d_sel <= int_state_out(3);
o_d_load <= int_s3_s4;
o_d_shiftr <= int_divs or int_not_divs;

o_q_shift_in <= int_divs;
o_q_load <= int_state_out(13);
o_q_clear <= int_state_out(0);
o_q_shiftl <= int_divs or int_not_divs;

o_add_left_sel <= int_divs;
o_add_right_sel(0) <= int_state_out(3) or int_state_out(13);
o_add_right_sel(1) <= int_divs or int_state_out(13);
o_addbar_sub <= int_state_out(1) or int_state_out(3) or int_divs or int_state_out(13);

o_neg_load <= int_state_out(1) or int_state_out(3);
o_neg_clear <= int_state_out(0);

o_output_load <= int_state_out(14);
end struct;