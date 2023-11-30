library IEEE;
use IEEE.std_logic_1164.all;

entity topest_level is
	port (i_clk, i_reset, i_sscs : in std_logic;
			i_mslt, i_sslt : in std_logic_vector(3 downto 0);
			o_txd : out std_logic;
			o_mstl, o_sstl : out std_logic_vector(2 downto 0);
			o_bcd_1, o_bcd_2 : out std_logic_vector(3 downto 0) --1 tens, 2 ones
			);
end topest_level;

architecture struct of topest_level is

component top_level is
	port(i_gclock, i_greset : in std_logic;
			i_msc, i_ssc : in std_logic_vector(3 downto 0);
			i_sscs : in std_logic;
			o_mstl, o_sstl : out std_logic_vector(2 downto 0); --ryg
			o_bcd1, o_bcd2 : out std_logic_vector(3 downto 0); --left, right diget
			o_lightstate : out std_logic_vector(1 downto 0)
		 );
end component;

component uart_fsm is
	port(i_clock, i_reset, i_tx_ready : in std_logic;
		i_light_state : in std_logic_vector(1 downto 0);
		o_transmit_byte : out std_logic;
		o_transmit_data : out std_logic_vector(6 downto 0));
end component;

component transmitter_top_level is
	port ( i_reset: in std_logic;
			 i_clock: in std_logic;
			 i_data: in std_logic_vector(6 downto 0);
			 i_transmitByte: in std_logic;
			 o_Tx_Busy: out std_logic;
			 o_TxData: out std_logic);
end component;

signal int_mstl, int_sstl : std_logic_vector(2 downto 0);
signal int_bcd1, int_bcd2 : std_logic_vector(3 downto 0);

signal int_tx_ready, int_tx_busy : std_logic;
signal int_lightstate : std_logic_vector(1 downto 0);

signal int_transmit_byte : std_logic;
signal int_transmit_data : std_logic_vector(6 downto 0);
signal int_data : std_logic;
begin

lab3_impl: top_level port map (i_clk, i_reset, i_mslt, i_sslt, i_sscs, int_mstl, int_sstl, int_bcd1, int_bcd2, int_lightstate);
o_mstl <= int_mstl;
o_sstl <= int_sstl;
o_bcd_1 <= int_bcd1;
o_bcd_2 <= int_bcd2;

--May need to change clock speed for this bad boy
uart_fasm_impl: uart_fsm port map (i_clk, i_reset, int_tx_ready, int_lightstate, int_transmit_byte, int_transmit_data);

transmitter_top_level_impl: transmitter_top_level port map (i_reset, i_clk, int_transmit_data, int_transmit_byte, int_tx_busy, int_data);
int_tx_ready <= not(int_tx_busy);

o_txd <= int_data;
end struct;