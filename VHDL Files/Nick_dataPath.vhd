LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Nick_dataPath IS
	PORT(
				--Control Signals--
		i_LoadInput, i_LoadDisplay,i_LoadPhase, i_ShiftPhase,
		i_LoadOperand, i_LoadProductSign, i_OperationFinished, i_ComplementProduct, 
		i_AddProduct, i_ShiftMultiplicandLeft, i_ShiftMultiplierRight, i_LatchProduct: IN	STD_LOGIC;
		
				--Inputs--
		i_InputA, i_InputB								: IN	STD_LOGIC_VECTOR( 3 downto 0);
		i_clock												: IN	STD_LOGIC;
		
				--Outputs--
		o_ProductSign, o_MultiplierEmpty, o_LSB_Multiplier : OUT	STD_LOGIC;
		o_Phase : OUT STD_LOGIC_VECTOR (2 downto 0);
		o_Output : OUT STD_LOGIC_VECTOR (7 downto 0));
		
END Nick_dataPath;

ARCHITECTURE Structural of Nick_dataPath IS
	--SIGNALS--
	SIGNAL int_MSB_A, int_MSB_B 								: STD_LOGIC;
	SIGNAL int_AInput,int_AComplemented, int_APositive : STD_LOGIC_VECTOR( 3 downto 0);
	SIGNAL int_BInput,int_BComplemented, int_BPositive : STD_LOGIC_VECTOR( 3 downto 0);
	
	SIGNAL int_Multiplicand 									: STD_LOGIC_VECTOR( 7 downto 0);
	SIGNAL int_Multiplier 										: STD_LOGIC_VECTOR( 3 downto 0);
	
	SIGNAL int_Sum 												: STD_LOGIC_VECTOR( 7 downto 0);
	SIGNAL int_ProductInput, int_ProductOutput 			: STD_LOGIC_VECTOR( 7 downto 0);
	SIGNAL int_ProductComplemented 							: STD_LOGIC_VECTOR( 7 downto 0);
	SIGNAL int_DisplayInput, int_DisplayOutput			: STD_LOGIC_VECTOR( 7 downto 0);
	
	SIGNAL int_ProductSignInput, int_ProductSignOutput	: STD_LOGIC;
	SIGNAL int_PhaseOutput										: STD_LOGIC_VECTOR(2 downto 0);
	
	SIGNAL int_Output : STD_LOGIC_VECTOR( 7 downto 0);
	
	--COMPONENTS--
	
	COMPONENT Load_PIPO_4_Bit_Register IS
		PORT(
			i_load 						: IN 	STD_LOGIC;
			i_parallelInput			: IN	STD_LOGIC_VECTOR (3 downto 0);
			i_clock						: IN	STD_LOGIC;
			o_q, o_qBar					: OUT	STD_LOGIC_VECTOR (3 downto 0));
	END COMPONENT;
	
	COMPONENT twos_Complementer_4_Bit is
		port(
			i_input 	: in std_logic_vector(3 downto 0);
			o_output	: out std_logic_vector(3 downto 0));
	end component;
	
	COMPONENT Nick_MUX_8_To_4 is
		port(i_1, i_0 : in STD_LOGIC_VECTOR(3 downto 0);
				i_Selector 		: IN	STD_LOGIC ;	
				o : out STD_LOGIC_VECTOR(3 downto 0));
	end COMPONENT;
	
	COMPONENT universal_8_Bit_Logical_Shift_Left_Register IS
		PORT(
			i_load, i_shiftLeft, i_shiftRight			: IN	STD_LOGIC;			
			i_parallelInput									: IN	STD_LOGIC_VECTOR( 7 downto 0);			
			i_clock												: IN	STD_LOGIC;			
			o_q, o_qBar											: OUT	STD_LOGIC_VECTOR( 7 downto 0));			
	END COMPONENT;
	
	COMPONENT universal_4_Bit_Logical_Shift_Right_Register IS
		PORT(
			i_load, i_shiftLeft, i_shiftRight			: IN	STD_LOGIC;			
			i_parallelInput									: IN	STD_LOGIC_VECTOR( 3 downto 0);			
			i_clock												: IN	STD_LOGIC;			
			o_q, o_qBar											: OUT	STD_LOGIC_VECTOR( 3 downto 0));			
	END COMPONENT;
	
	COMPONENT add_sub_8 is
		port(i_a, i_b 				: in std_logic_vector(7 downto 0);
			i_op 						: in std_logic; -- 0 add 1 sub
			o_sum 					: out std_logic_vector(7 downto 0);
			o_carry, o_overflow 	: out std_logic);
	end COMPONENT;
	
	COMPONENT Nick_MUX_32_To_8 is
		port(i_3, i_2, i_1, i_0 : in STD_LOGIC_VECTOR(7 downto 0);
				i_Selector 		: IN	STD_LOGIC_VECTOR(1 downto 0);		
				o : out STD_LOGIC_VECTOR(7 downto 0));
	end COMPONENT;
	
	COMPONENT PIPO_8_Bit_Register is
		PORT(
			i_parallelInput			: IN	STD_LOGIC_VECTOR (7 downto 0);
			i_clock						: IN	STD_LOGIC;
			o_q, o_qBar					: OUT	STD_LOGIC_VECTOR (7 downto 0));			  
	END COMPONENT;
	
	COMPONENT twos_Complementer_8_Bit is
		port(	i_input 	: in std_logic_vector(7 downto 0);
				o_output	: out std_logic_vector(7 downto 0));
	END COMPONENT;
	
	COMPONENT Load_PIPO_8_Bit_Register is
		PORT(
			i_load 						: IN 	STD_LOGIC;
			i_parallelInput			: IN	STD_LOGIC_VECTOR (7 downto 0);
			i_clock						: IN	STD_LOGIC;
			o_q, o_qBar					: OUT	STD_LOGIC_VECTOR (7 downto 0));			  
	END COMPONENT;
	
	COMPONENT load_dFF_1 IS
		PORT(
			i_load				:	IN STD_LOGIC;
			i_parallelInput 	:	IN STD_LOGIC;
			i_clock				:	IN	STD_LOGIC;
			o_q, o_qBar			:	OUT	STD_LOGIC);
	END COMPONENT;
	
	COMPONENT universal_3_Bit_Register IS

	PORT(
		i_load, i_shiftLeft, i_shiftRight			: IN	STD_LOGIC;		
		i_parallelInput									: IN	STD_LOGIC_VECTOR( 2 downto 0);		
		i_clock												: IN	STD_LOGIC;
		o_q, o_qBar											: OUT	STD_LOGIC_VECTOR( 2 downto 0));		
	END COMPONENT;
	
BEGIN
	--Signal Assignment--
	int_MSB_A <= int_AInput(3);
	int_MSB_B <= int_BInput(3);
	int_ProductSignInput <= int_MSB_A XOR int_MSB_B;
	
	--Input A--
	A_Register					:	Load_PIPO_4_Bit_Register PORT MAP (i_LoadInput,i_InputA,i_clock,int_AInput, OPEN);
	A_Complementer				: 	twos_Complementer_4_Bit	 PORT MAP (int_AInput,int_AComplemented);
	A_8x4_MUX					:	Nick_MUX_8_To_4 			 PORT MAP (int_AComplemented,int_AInput,int_MSB_A,int_APositive);
	Multiplicand_Register	:	universal_8_Bit_Logical_Shift_Left_Register PORT MAP (i_LoadOperand,i_ShiftMultiplicandLeft,'0',"0000" & int_APositive,i_clock,int_Multiplicand,OPEN);
	
	--Input B--
	B_Register					:	Load_PIPO_4_Bit_Register PORT MAP (i_LoadInput,i_InputB,i_clock,int_BInput, OPEN);
	B_Complementer				: 	twos_Complementer_4_Bit	 PORT MAP (int_BInput,int_BComplemented);
	B_8x4_MUX					:	Nick_MUX_8_To_4			 PORT MAP (int_BComplemented,int_BInput,int_MSB_B,int_BPositive);
	Multiplier_Register		:	universal_4_Bit_Logical_Shift_Right_Register PORT MAP (i_LoadOperand,'0',i_ShiftMultiplierRight,int_BPositive,i_clock,int_Multiplier,OPEN);
	
	--Computation--
	Adder							:	add_sub_8 					 PORT MAP (int_ProductOutput,int_Multiplicand,'0',int_Sum,OPEN,OPEN);
	Product_32x8_MUX			:	Nick_MUX_32_To_8			 PORT MAP (int_Sum,int_Sum,int_ProductOutput,"00000000",(i_AddProduct,i_LatchProduct),int_ProductInput);
	Product_Register			:	PIPO_8_Bit_Register		 PORT MAP (int_ProductInput,i_clock,int_ProductOutput,OPEN);
	
	--Display--
	Product_Complementer		:	twos_Complementer_8_Bit	 PORT MAP (int_ProductOutput,int_ProductComplemented);
	Display_32x8_MUX			:	Nick_MUX_32_To_8			 PORT MAP (int_ProductComplemented,int_ProductComplemented,int_ProductOutput,"00000000",(i_ComplementProduct,i_OperationFinished),int_DisplayInput);
	Display						:	Load_PIPO_8_Bit_Register PORT MAP (i_LoadDisplay,int_DisplayInput,i_clock,int_DisplayOutput,OPEN);
	
	--Product Sign--
	ProductSignFF				:	load_dFF_1 					 PORT MAP (i_LoadProductSign,int_ProductSignInput,i_clock,int_ProductSignOutput);
	
	--State Tracker--
	Phase_Register				:	universal_3_Bit_Register PORT MAP (i_LoadPhase,i_ShiftPhase,'0',"001",i_clock,int_PhaseOutput,OPEN);
	
	o_ProductSign 		<= int_ProductSignOutput;
	o_Phase 				<= int_PhaseOutput;
	o_MultiplierEmpty	<= not(int_Multiplier(3)) and not(int_Multiplier(2)) and not(int_Multiplier(1)) and not(int_Multiplier(0));
	o_LSB_Multiplier	<= int_Multiplier(0);
	
	o_Output	<= int_DisplayOutput;

END Structural;