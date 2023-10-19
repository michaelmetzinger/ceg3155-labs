LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY PIPO_8_Bit_Register is
	PORT(
		i_parallelInput			: IN	STD_LOGIC_VECTOR (7 downto 0);
		i_clock						: IN	STD_LOGIC;
		o_q, o_qBar					: OUT	STD_LOGIC_VECTOR (7 downto 0));
        
END PIPO_8_Bit_Register;

ARCHITECTURE struct OF PIPO_8_Bit_Register IS

SIGNAL int_q, int_qBar : std_logic_vector(7 downto 0);

COMPONENT dff_1 IS
	PORT(
		i_d				: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		o_q, o_qBar		: OUT	STD_LOGIC);
END COMPONENT;

BEGIN

	b7: dff_1 PORT MAP(i_parallelInput(7), i_clock, int_q(7), int_qBar(7));
	b6: dff_1 PORT MAP(i_parallelInput(6), i_clock, int_q(6), int_qBar(6));
	b5: dff_1 PORT MAP(i_parallelInput(5), i_clock, int_q(5), int_qBar(5));
	b4: dff_1 PORT MAP(i_parallelInput(4), i_clock, int_q(4), int_qBar(4));
	b3: dff_1 PORT MAP(i_parallelInput(3), i_clock, int_q(3), int_qBar(3));
	b2: dff_1 PORT MAP(i_parallelInput(2), i_clock, int_q(2), int_qBar(2));
	b1: dff_1 PORT MAP(i_parallelInput(1), i_clock, int_q(1), int_qBar(1));
	b0: dff_1 PORT MAP(i_parallelInput(0), i_clock, int_q(0), int_qBar(0));
	

o_q <= int_q;
o_qBar <= int_qBar;

END struct;