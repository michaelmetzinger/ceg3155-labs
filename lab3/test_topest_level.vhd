library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_topest_level is
end test_topest_level;

architecture test of test_topest_level is

component topest_level is
	port (i_clk, i_reset, i_sscs : in std_logic;
			i_mslt, i_sslt : in std_logic_vector(3 downto 0);
			o_txd : out std_logic;
			o_mstl, o_sstl : out std_logic_vector(2 downto 0);
			o_bcd_1, o_bcd_2 : out std_logic_vector(3 downto 0) --1 tens, 2 ones
			);
end component;

signal i_clk : std_logic := '0';
signal i_reset, i_sscs : std_logic;

signal i_mslt, i_sslt : std_logic_vector(3 downto 0);
signal o_txd : std_logic;
signal o_mstl, o_sstl : std_logic_vector(2 downto 0);
signal o_bcd_1, o_bcd_2 : std_logic_vector(3 downto 0);

begin
impl: topest_level
	port map(i_clk, i_reset, i_sscs, i_mslt, i_sslt, o_txd, o_mstl, o_sstl, o_bcd_1, o_bcd_2);



i_clk <= not(i_clk) after 1 ns;
i_mslt <= "1111";
i_sslt <= "1111";

stimulus: process begin
	i_reset <= '1';
	i_sscs <= '1';
	wait for 5 ns;
	
	i_reset <= '0';
	wait for 10000 ns;

end process;	

end test;