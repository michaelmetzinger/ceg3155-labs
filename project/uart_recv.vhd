library IEEE;
use IEEE.std_logic_1164.all;

entity uart_recv is
	port(
		i_RxD, i_RIE, i_clock, i_reset : in std_logic;
		o_RDR : out std_logic_vector(6 downto 0);
		o_OE, o_FE, o_RDRF : out std_logic
	);
end uart_recv;

architecture struct of uart_recv is
component reg is
	generic (bits : integer := 1);
	port ( i_data : in std_logic_vector(bits downto 1);
			i_load : in std_logic;
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1));
end component;

component reg_shiftr is
	generic (bits : integer := 1);
	port ( i_shift_in : in std_logic; --Data in
			i_shift : in std_logic; -- Shift
			i_clock : in std_logic;
			o_data : out std_logic_vector(bits downto 1);
			o_shift_out : out std_logic);
end component;

component counter_4 is
	port(i_clock, i_clear : in std_logic;
			output : out std_logic_vector(3 downto 0));
end component;

component cmp is
	generic (bits : integer := 2); --must be 2 or greater. use cmp_1 for 1 bit.
	port (i_a, i_b : in std_logic_vector(bits downto 1);
			o_gt, o_eq, o_lt : out std_logic);
end component;

component uart_recv_ctrl  is 
	port(
		--inputs
		i_RxD, i_RIE, i_clock, i_reset,
		i_timer_done, i_RDRF_data_out : in std_logic;
		--outputs
		o_load_RDR, o_shift_RSR, o_load_FE, o_load_OE, o_load_RDRF, o_counter_clear,
		o_FE_data_in, o_OE_data_in, o_RDRF_data_in : out std_logic;
		o_endcount : out std_logic_vector(3 downto 0)
	);
end component;

signal int_load_RDR : std_logic;
signal int_RDR_data_out, int_RDR_data_in : std_logic_vector(6 downto 0);

signal int_shift_RSR : std_logic;
signal int_RSR_data_out : std_logic_vector(6 downto 0);

signal int_FE_data_in, int_FE_data_out : std_logic_vector(0 downto 0);
signal int_load_FE : std_logic;

signal int_OE_data_in, int_OE_data_out : std_logic_vector(0 downto 0);
signal int_load_OE : std_logic;

signal int_RDRF_data_in, int_RDRF_data_out : std_logic_vector(0 downto 0);
signal int_load_RDRF : std_logic;

signal int_counter_clear : std_logic;
signal int_count : std_logic_vector(3 downto 0);

signal int_endcount : std_logic_vector(3 downto 0);
signal int_timer_done, int_not_timer_done : std_logic;
begin

--components
RDR: reg generic map (bits => 7)
	port map(int_RDR_data_in, int_load_RDR, i_clock, int_RDR_data_out);

RSR: reg_shiftr generic map (bits => 7)
	port map(i_shift_in => i_RxD, i_shift => int_shift_RSR, i_clock => i_clock,
		o_data => int_RSR_data_out
	);

FE_reg: reg generic map (bits => 1)
	port map(int_FE_data_in, int_load_FE, i_clock, int_FE_data_out);

OE_reg: reg generic map (bits => 1)
	port map(int_OE_data_in, int_load_OE, i_clock, int_OE_data_out);

RDRF_reg: reg generic map (bits => 1)
	port map(int_RDRF_data_in, int_load_RDRF, i_clock, int_RDRF_data_out);
	
counter: counter_4 port map(i_clock, int_counter_clear, int_count);

cmp_4_bits: cmp generic map (bits => 4)
	port map (i_a => int_count, i_b => int_endcount, o_lt => int_not_timer_done);
int_timer_done <= not(int_not_timer_done);

ctrl: uart_recv_ctrl port map(
		--inputs
		i_RxD, i_RIE, i_clock, i_reset,
		int_timer_done, int_RDRF_data_out(0),
		--outputs
		int_load_RDR, int_shift_RSR, int_load_FE, int_load_OE, int_load_RDRF, int_counter_clear,
		int_FE_data_in(0), int_OE_data_in(0), int_RDRF_data_in(0),
		int_endcount
	);

--reset RDR
l: for i in 0 to 6 generate
	int_RDR_data_in(i) <= int_RSR_data_out(i) and not(i_reset);
end generate;
	
--output
o_RDR <= int_RDR_data_out;
o_OE <= int_OE_data_out(0);
o_FE <= int_FE_data_out(0);
o_RDRF <= int_RDRF_data_out(0);

end struct;