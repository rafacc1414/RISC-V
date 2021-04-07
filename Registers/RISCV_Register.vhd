-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use work.pkg.all;

entity RISCV_Register is

generic(n:integer:=32);

port
(
	CLK : in std_logic;
	D   : in std_logic_vector(n-1 downto 0);
	E   : in std_logic; -- enable
	Q   : out std_logic_vector(n-1 downto 0)
);
end RISCV_Register;

-- architecture
architecture rtl of RISCV_Register is
begin

	-- There is one flip-flop type D for each bit. This implement a parallel input/output register
	FlipsFlops: for i in 0 to D'high generate
		d0:FF_D
		port map(clk=>clk, D =>D(i),E=>E, Q=>Q(i));
	end generate;

end rtl;