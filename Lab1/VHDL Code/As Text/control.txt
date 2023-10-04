library IEEE;
use IEEE.std_logic_1164.all;

entity control is
	port(i_greset, i_left, i_right : in std_logic;
    	i_clock : in std_logic;
        o_load, o_rshift, o_lshift, o_display_sel_1, o_display_sel_0 : out std_logic);
end control;

architecture struct of control is
	signal int_s0_cond, int_s1_cond, int_s2_cond, int_s3_cond : std_logic;
	signal int_s0, int_s1, int_s2, int_s3 : std_logic;


	component dFF_1 is
		port (i_d : in std_logic;
			i_clock : in std_logic;
			o_q : out std_logic;
			o_qbar : out std_logic);
	end component;

begin
	int_s0_cond <= i_greset;
	int_s1_cond <= i_left and i_right and not(i_greset);
	int_s2_cond <= i_left and not(i_greset) and not(i_right);
	int_s3_cond <= i_right and not(i_greset) and not(i_left);

	dff0: dFF_1
		port map(i_d => int_s0_cond,
		 i_clock => i_clock,
		 o_q => int_s0);

	dff1: dFF_1
		port map(i_d => int_s1_cond,
		 i_clock => i_clock,
		 o_q => int_s1); 

	dff2: dFF_1
		port map(i_d => int_s2_cond,
		 i_clock => i_clock,
		 o_q => int_s2);

	dff3: dFF_1
		port map(i_d => int_s3_cond,
		 i_clock => i_clock,
		 o_q => int_s3);

	o_load <= int_s0;

	o_rshift <= int_s1 or int_s3;
	o_display_sel_1 <= int_s1 or int_s3;

	o_lshift <= int_s1 or int_s2;
	o_display_sel_0 <= int_s1 or int_s2;

end struct;