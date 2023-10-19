library IEEE;
use IEEE.std_logic_1164.all;

entity Nick_controlPath is
	port(	
			--Inputs--
			i_GReset	:in std_logic;
			i_ProductSign, i_MultiplierEmpty, i_LSB_Multiplier : in std_logic;
			i_Phase		:in std_logic_vector(2 downto 0);
			i_clock : in std_logic;
			--Outputs--
			o_LoadInput, o_LoadDisplay, o_LoadPhase, o_ShiftPhase, o_LoadOperand, o_LoadProductSign, o_OperationFinished,o_ComplementProduct, 
			o_AddProduct, o_ShiftMultiplicandLeft,o_ShiftMultiplierRight,o_LatchProduct: out std_logic);
end Nick_controlPath;

architecture struct of Nick_controlPath is
	signal int_s0_cond, int_s1_cond, int_s2_cond, int_s3_cond, int_s4_cond, int_s5_cond, int_s6_cond  : std_logic;
	signal int_s0, int_s1, int_s2, int_s3, int_s4, int_s5, int_s6 : std_logic;


	component dFF_1 is
		port (i_d : in std_logic;
			i_clock : in std_logic;
			o_q : out std_logic;
			o_qbar : out std_logic);
	end component;

begin
	int_s0_cond <= i_greset; --load in inputs and reset values--
	int_s1_cond <= i_Phase(0) and (not(i_greset)); --load appropriate operands and move to multiplying--
	
	int_s2_cond <= i_Phase(1) and (not(i_MultiplierEmpty)) and i_LSB_Multiplier and (not(i_GReset)); --shift and add--
	int_s3_cond <= i_Phase(1) and (not(i_MultiplierEmpty)) and (not(i_LSB_Multiplier)) and (not(i_GReset)); --shift
	int_s4_cond <= i_Phase(1) and (i_MultiplierEmpty) and (not(i_GReset)); --move to display--
		
	int_s5_cond <= i_Phase(2) and i_ProductSign and (not(i_GReset)); --display complemented product--
	int_s6_cond <= i_Phase(2) and (not(i_ProductSign)) and (not(i_GReset)); --display uncomplemented product--

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
		 
	dff4: dFF_1
		port map(i_d => int_s4_cond,
		 i_clock => i_clock,
		 o_q => int_s4);

	dff5: dFF_1
		port map(i_d => int_s5_cond,
		 i_clock => i_clock,
		 o_q => int_s5);
		 
	dff6: dFF_1
		port map(i_d => int_s6_cond,
		 i_clock => i_clock,
		 o_q => int_s6);			 
		 
	o_LoadInput <= int_s0;
	o_LoadDisplay <= int_s0 or int_s5 or int_s6;
	o_LoadPhase	<= int_s0;
	
	o_LoadOperand <= int_s1;
	o_LoadProductSign <= int_s1;
	o_ShiftPhase <= int_s1 or int_s4;
	
	o_AddProduct 				<= int_s2;
	o_ShiftMultiplicandLeft <= int_s2 or int_s3;
	o_ShiftMultiplierRight	<= int_s2 or int_s3;	
	o_LatchProduct				<= int_s3;
	
	o_OperationFinished <= int_s5 or int_s6;
	o_ComplementProduct <= int_s5;

		 
end struct;