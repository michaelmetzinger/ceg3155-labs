library IEEE;
use IEEE.std_logic_1164.all;

entity div_top_level is
	port (
		i_a, i_b : in std_logic_vector(3 downto 0);
		i_clock, i_reset : in std_logic;
		o_output, o_remainder : out std_logic_vector(3 downto 0)
	);
end div_top_level;

architecture struct of div_top_level is
signal int_gt,
	int_neg,
	int_neg_a, int_neg_b,
	int_r_load, int_r_sel, 
	int_d_sel, int_d_load, int_d_shiftr, 
	int_q_shift_in, int_q_load, int_q_clear, int_q_shiftl,
	int_add_left_sel,
	int_addbar_sub,
	int_neg_load, int_neg_clear,
	int_output_load : std_logic;
signal int_add_right_sel : std_logic_vector(1 downto 0);
signal int_output, int_remainder : std_logic_vector(3 downto 0);
	
component div_data is
	port (
		i_a, i_b : std_logic_vector(3 downto 0);
		i_clock : in std_logic;
		i_r_load, i_r_sel, 
		i_d_sel, i_d_load, i_d_shiftr, 
		i_q_shift_in, i_q_load, i_q_clear, i_q_shiftl,
		i_add_left_sel	: in std_logic;
		i_add_right_sel : in std_logic_vector(1 downto 0);
		i_addbar_sub,
		i_neg_load, i_neg_clear,
		i_output_load : in std_logic;
		
		o_gt : out std_logic;
		o_neg : out std_logic;
		o_neg_a, o_neg_b : out std_logic;
		o_output, o_remainder : out std_logic_vector(3 downto 0)
	);
end component;

component div_control is
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
end component;

begin

ctrl: div_control port map (
	i_clock,
	i_reset,
	int_gt,
	int_neg,
	int_neg_a, int_neg_b,
	int_r_load, int_r_sel, 
	int_d_sel, int_d_load, int_d_shiftr, 
	int_q_shift_in, int_q_load, int_q_clear, int_q_shiftl,
	int_add_left_sel,
	int_add_right_sel,
	int_addbar_sub,
	int_neg_load, int_neg_clear,
	int_output_load
);

data: div_data port map (
	i_a, i_b, i_clock,
	int_r_load, int_r_sel, 
	int_d_sel, int_d_load, int_d_shiftr, 
	int_q_shift_in, int_q_load, int_q_clear, int_q_shiftl,
	int_add_left_sel,
	int_add_right_sel,
	int_addbar_sub,
	int_neg_load, int_neg_clear,
	int_output_load,
	
	int_gt,
	int_neg,
	int_neg_a, int_neg_b,
	int_output, int_remainder
);

o_output <= int_output;
o_remainder <= int_remainder;
end struct;