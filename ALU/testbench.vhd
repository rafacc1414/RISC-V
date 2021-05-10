-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end entity testbench;

architecture tb of testbench is


component ALU is
generic (N: natural :=32);
port
(
	CLK      : in  std_logic;
	A        : in  std_logic_vector (N-1 downto 0);
	B        : in  std_logic_vector (N-1 downto 0);
	Funct_3  : in  std_logic_vector (2   downto 0);
	Funct_7  : in  std_logic_vector (6   downto 0);
	Result   : out std_logic_vector (N-1 downto 0);
	Zero     : out std_logic;
	Sign     : out std_logic;
	Overflow : out std_logic
);
end component ALU;

	signal clk,z,s,o : std_logic := '0';
	signal a,b,r     : std_logic_vector (3 downto 0) := "0000";
	signal f3        : std_logic_vector (2 downto 0) := "000";
	signal f7        : std_logic_vector (6 downto 0) := "0000000";
	signal One       : std_logic_vector (3 downto 0) := "0001";
	constant CLK_PERIOD : time := 20 ns;
	constant N_nat      : natural := 4;
	signal done : boolean := false;
	
begin
	
	b <= "0001";

	gen_clk: process(clk) is
	begin
		if not done then
			clk <= not clk after CLK_PERIOD/2;
		else
			clk <= '0';
		end if;
	end process gen_clk;
	
	A_stimulus : process is
	begin
		if not done then
			wait for 2*CLK_PERIOD;
			a  <= std_logic_vector(unsigned(a) + unsigned(One));
		end if;
	end process A_stimulus;
	
	F7_F3_stimulus : process is
	begin
		if not done then
			wait for 33*CLK_PERIOD;
			f7 <= "0100000";
		end if;
	end process F7_F3_stimulus;
	
	uut_ALU : ALU generic map(N => 4)
	port map (clk,a,b,f3,f7,r,z,s,o);
	
	
end tb;
