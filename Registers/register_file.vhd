-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.register_pkg.all;

entity RISCV_Register_file is

generic(
	n:integer:=32;		-- Number of registers
	n_cod:integer:=5	-- Number of bits to codify the n posibles registers
);

port (
	CLK		 	  : in std_logic;
	we 			  : in std_logic;                          -- we = Write enable
	rs1,rs2 	  : in std_logic_vector(n_cod-1 downto 0); -- rs = Read Selection	
	ws			  : in std_logic_vector(n_cod-1 downto 0); -- ws = Write Selection
	wd 			  : in std_logic_vector(n-1 downto 0);     -- wd = Write Data
	rd1,rd2		  : out std_logic_vector(n-1 downto 0);    -- rd = Read Data
	read_validity : out std_logic
);
end RISCV_Register_file;

-- architecture
architecture rtl of RISCV_Register_file is

	type signals is array (0 to 31) of std_logic_vector(31 downto 0);   -- we create an array type which each cell of the array contains an std_logic_vector of 32 bits
	signal input_register   : signals := (others => (others => '0'));   -- Intermidiate signal which contains the input of the registers
	signal output           : signals := (others => (others => '0'));   -- Intermidiate signal which contains the ouput of the registers

begin
	Registers: for i in 0 to n-1 generate
		R:RISCV_Register
		port map(clk=>clk, D => input_register(i), E=>we, Q=>output(i));
	end generate; 

	READ: process(rs1,rs2)
	begin
		rd1 <= output(to_integer(unsigned(rs1)));
		rd2 <= output(to_integer(unsigned(rs2)));
		read_validity <= '1';
	end process READ;

	read_validity_process : process (CLK)
	begin
		if (falling_edge(CLK)) then
			read_validity <= '0';
		end if;
	end process read_validity_process;

	WRITE: process(CLK)
	begin
		if (rising_edge(CLK)) then
			input_register(to_integer(unsigned(ws))) <= wd;
		else
			input_register(to_integer(unsigned(ws))) <= input_register(to_integer(unsigned(ws)));
		end if;
	end process WRITE; 
end rtl;