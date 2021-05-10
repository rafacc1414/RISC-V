library ieee;
use ieee.std_logic_1164.all;

package pkg is

	component FF_D is
	port 
	(
		CLK : in std_logic;
		D   : in std_logic;
		E   : in std_logic; -- enable
		Q   : out std_logic
	);
	end component FF_D;
	
	component RISCV_Register is
	generic(n:integer:=32);
	port 
	(
		CLK : in std_logic;
		D   : in std_logic_vector(n-1 downto 0);
		E   : in std_logic; -- enable
		Q   : out std_logic_vector(n-1 downto 0)
	);
	end component RISCV_Register;
	
	
	component RISCV_Register_file is
	generic
	(
		n:integer:=32;		-- Number of registers
		n_cod:integer:=5	-- Number of bits to codify the n posibles registers
	);		
		
	port 
	(
		CLK           : in std_logic;
		we            : in std_logic;                          -- we = Write enable
		rs1,rs2       : in std_logic_vector(n_cod-1 downto 0); -- rs = Read Selection	
		ws            : in std_logic_vector(n_cod-1 downto 0); -- ws = Write Selection
		wd            : in std_logic_vector(n-1 downto 0);     -- wd = Write Data
		rd1,rd2       : out std_logic_vector(n-1 downto 0);    -- rd = Read Data
		read_validity : out std_logic
	);      
	end component RISCV_Register_file;
	
	component Instruction_Memory is
	port 
	(
		ReadAddr : in std_logic_vector (3 downto 0);
		Instruction : out std_logic_vector (31 downto 0)
	);
	end component Instruction_Memory;

end package pkg;