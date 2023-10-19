LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Load_PIPO_4_Bit_Register is
	PORT(
		i_load 						: IN 	STD_LOGIC;
		i_parallelInput			: IN	STD_LOGIC_VECTOR (3 downto 0);
		i_clock						: IN	STD_LOGIC;
		o_q, o_qBar					: OUT	STD_LOGIC_VECTOR (3 downto 0));
        
END Load_PIPO_4_Bit_Register;

ARCHITECTURE struct OF Load_PIPO_4_Bit_Register IS

SIGNAL int_q, int_qBar : std_logic_vector(3 downto 0);

COMPONENT load_dff_1 IS
	PORT(
		i_load	:IN STD_LOGIC;
		
		i_parallelInput :IN STD_LOGIC;
		
		i_clock			: IN	STD_LOGIC;
		o_q, o_qBar		: OUT	STD_LOGIC);
END COMPONENT;

BEGIN

	b3: load_dff_1 PORT MAP(i_load, i_parallelInput(3), i_clock, int_q(3), int_qBar(3));
	b2: load_dff_1 PORT MAP(i_load, i_parallelInput(2), i_clock, int_q(2), int_qBar(2));
	b1: load_dff_1 PORT MAP(i_load, i_parallelInput(1), i_clock, int_q(1), int_qBar(1));
	b0: load_dff_1 PORT MAP(i_load, i_parallelInput(0), i_clock, int_q(0), int_qBar(0));
	

o_q <= int_q;
o_qBar <= int_qBar;

END struct;