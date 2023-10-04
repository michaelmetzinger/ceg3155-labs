LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity Register_8_Bit is
	port(
		i_parallelInput			: IN	STD_LOGIC_VECTOR (7 downto 0);
		i_clock						: IN	STD_LOGIC;
		o_q, o_qBar					: OUT	STD_LOGIC_VECTOR (7 downto 0));
        
end Register_8_Bit;

architecture struct of Register_8_Bit is

signal int_q, int_qBar : std_logic_vector(7 downto 0);

component dff_1 is
	port (i_d			: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		o_q, o_qBar		: OUT	STD_LOGIC);
end component;

begin

	b7: dFF_1 port map(i_parallelInput(7), i_clock, int_q(7), int_qBar(7));
	b6: dFF_1 port map(i_parallelInput(6), i_clock, int_q(6), int_qBar(6));
	b5: dFF_1 port map(i_parallelInput(5), i_clock, int_q(5), int_qBar(5));
	b4: dFF_1 port map(i_parallelInput(4), i_clock, int_q(4), int_qBar(4));
	b3: dFF_1 port map(i_parallelInput(3), i_clock, int_q(3), int_qBar(3));
	b2: dFF_1 port map(i_parallelInput(2), i_clock, int_q(2), int_qBar(2));
	b1: dFF_1 port map(i_parallelInput(1), i_clock, int_q(1), int_qBar(1));
	b0: dFF_1 port map(i_parallelInput(0), i_clock, int_q(0), int_qBar(0));
	

o_q <= int_q;
o_qBar <= int_qBar;

end struct;