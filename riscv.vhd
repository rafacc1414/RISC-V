library IEEE;
use IEEE.std_logic_1164.all;
use work.pkg.all;

entity RISCV is
port
(
	CLK         : in std_logic;
	PC          : in std_logic_vector (3 downto 0);
	Instruction : out std_logic_vector(31 downto 0);
	ALU_Result  : out std_logic_vector (31 downto 0)
);
end entity RISCV;

architecture test of RISCV is
	signal PC_Sync         : std_logic_vector (3 downto 0);
	signal Aux_Instruction : std_logic_vector (31 downto 0);
	signal Aux_ALU_Result  : std_logic_vector (31 downto 0); 
	signal WE_REG          : std_logic := '0';
	signal RD_1, RD_2      : std_logic_vector (31 downto 0);
	signal read_validity   : std_logic;
begin
	-- FF at the entry
	input_reg : process(CLK)
	begin
		if (rising_edge(CLK)) then
			PC_Sync  <= PC;
		end if;
	end process input_reg;
	
	Ins_Mem : Instruction_Memory 
	port map (PC_Sync, Aux_Instruction);
	
	RISCV_Reg : RISCV_Register_file
	generic map 
	(
		N => 32,
		N_cod => 5
	)
	port map
	(
		CLK => CLK,                            -- : in std_logic;           
		we  => WE_REG,                         -- : in std_logic;                          // we = Write enable
		rs1 => Aux_Instruction (19 downto 15), -- : in std_logic_vector(n_cod-1 downto 0); // rs = Read Selection   
		rs2 => Aux_Instruction (24 downto 20), -- : in std_logic_vector(n_cod-1 downto 0); // rs = Read Selection   
		ws  => Aux_Instruction (11 downto 7),  -- : in std_logic_vector(n_cod-1 downto 0); // ws = Write Selection
		wd  => Aux_ALU_Result,                 -- : in std_logic_vector(n-1 downto 0);     // wd = Write Data
		rd1 => RD_1,                           -- : out std_logic_vector(n-1 downto 0)     // rd = Read Data
		rd2 => RD_2,
		read_validity => read_validity); 
	
	Instruction <= Aux_Instruction;
	ALU_Result <= (others => '0');
	
end test;