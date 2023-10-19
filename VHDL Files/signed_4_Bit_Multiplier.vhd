LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY signed_4_Bit_Multiplier IS
	PORT(
				--Inputs--
		i_InputA, i_InputB								: IN	STD_LOGIC_VECTOR( 3 downto 0);
		i_GReset												: IN	STD_LOGIC;
		i_clock												: IN	STD_LOGIC;
		
		--Outputs--
		o_Output : OUT STD_LOGIC_VECTOR (7 downto 0));
		
END signed_4_Bit_Multiplier;

architecture struct of signed_4_Bit_Multiplier is
	SIGNAL 	int_LoadInput, int_LoadDisplay,int_LoadPhase, int_ShiftPhase,
				int_LoadOperand, int_LoadProductSign, int_OperationFinished, int_ComplementProduct, 
				int_AddProduct, int_ShiftMultiplicandLeft, int_ShiftMultiplierRight, int_LatchProduct:	STD_LOGIC; 
				
	SIGNAL	int_ProductSign, int_Preparation, int_MultiplierEmpty, int_LSB_Multiplier : STD_LOGIC;
	
	SIGNAL	int_Phase: STD_LOGIC_VECTOR (2 downto 0);
				
	SIGNAL	int_Output: STD_LOGIC_VECTOR (7 downto 0);
	
	
	component Nick_dataPath IS
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
		
END COMPONENT;
	
	component Nick_controlPath is
		port(	
			--Inputs--
			i_GReset	:in std_logic;
			i_ProductSign, i_MultiplierEmpty, i_LSB_Multiplier : in std_logic;
			i_Phase		:in std_logic_vector(2 downto 0);
			i_clock : in std_logic;
			--Outputs--
			o_LoadInput, o_LoadDisplay, o_LoadPhase, o_ShiftPhase, o_LoadOperand, o_LoadProductSign, o_OperationFinished,o_ComplementProduct, 
			o_AddProduct, o_ShiftMultiplicandLeft,o_ShiftMultiplierRight,o_LatchProduct: out std_logic);
		end component;

begin

	MyDataPath:	Nick_dataPath
		PORT MAP (int_LoadInput,int_LoadDisplay,int_LoadPhase,int_ShiftPhase,int_LoadOperand,int_LoadProductSign,int_OperationFinished,
					int_ComplementProduct,int_AddProduct,int_ShiftMultiplicandLeft,int_ShiftMultiplierRight,int_LatchProduct,
					i_InputA,i_InputB,i_clock,int_ProductSign,int_MultiplierEmpty, int_LSB_Multiplier, int_Phase, int_Output);
					
	MyControlPath: Nick_controlPath
	PORT MAP (i_GReset,int_ProductSign,int_MultiplierEmpty,int_LSB_Multiplier,int_Phase,i_clock,int_LoadInput, int_LoadDisplay,
				int_LoadPhase, int_ShiftPhase,int_LoadOperand, int_LoadProductSign, int_OperationFinished, int_ComplementProduct, 
				int_AddProduct, int_ShiftMultiplicandLeft, int_ShiftMultiplierRight, int_LatchProduct);
				
	o_Output<= int_Output;
end struct;