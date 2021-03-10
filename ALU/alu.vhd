-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
port
(
	CLK      : in  std_logic;
	A        : in  std_logic_vector (31 downto 0);
	B        : in  std_logic_vector (31 downto 0);
	Funct_3  : in  std_logic_vector (2  downto 0);
	Funct_7  : in  std_logic_vector (6  downto 0);
	Result   : out std_logic_vector (31 downto 0);
	Zero     : out std_logic;
	Sign     : out std_logic;
	Overflow : out std_logic
);
end entity alu;

architecture behavioral of alu is
		signal A_reg, B_reg : std_logic_vector (31 downto 0) := (others => '0');
		signal F3_reg       : std_logic_vector (2 downto 0)  := "000";
		signal F7_reg       : std_logic_vector (6 downto 0)  := "0000000";
		
		signal R_async                   : std_logic_vector (31 downto 0) := (others => '0');
		signal Z_async, S_async, O_async : std_logic := '0';
		
		type op_type is (ADD, SUB, SLLop, SLT, SLTU, XORop, SRLop, SRAop, ORop, ANDop, ERROR);
		signal Operation : op_type := ERROR;
		
begin

	input_reg : process(CLK)
	begin
		if (rising_edge(CLK)) then
			A_reg  <= A;
			B_reg  <= B;
			F3_reg <= Funct_3;
			F7_reg <= Funct_7;
		end if;
	end process input_reg;
		
	op_type_process : process (F3_reg, F7_reg)
	begin
		case F7_reg is
			when "0000000" =>
				case F3_reg is
					when "000" => Operation <= ADD;
					when "001" => Operation <= SLLop;
					when "010" => Operation <= SLT;
					when "011" => Operation <= SLTU;
					when "100" => Operation <= XORop;
					when "101" => Operation <= SRLop;
					when "110" => Operation <= ORop;
					when "111" => Operation <= ANDop;
					when others => Operation <= ERROR;
				end case;
			when "0100000" =>
				case F3_reg is
					when "000" => Operation <= SUB;
					when "101" => Operation <= SRAop;
					when others => Operation <= ERROR;
				end case;
			when others => Operation <= ERROR;
		end case;
	end process op_type_process;
		
	op_calc_process : process (Operation, A_reg, B_reg)
	begin
		case Operation is
			when ADD =>
				R_async <= std_logic_vector (unsigned (A_reg) + unsigned(B_reg));
			when SUB =>
				R_async <= std_logic_vector (unsigned (A_reg) - unsigned(B_reg));
			when SLLop =>
				R_async <= (others => '0');
			when others =>
				R_async <= (others => '0');
		end case;
	end process op_calc_process;
		
	output_reg : process(CLK)
	begin
		if (rising_edge(CLK)) then
			Result   <= R_async;
			Zero     <= Z_async;
			Sign     <= S_async;
			Overflow <= O_async;
		end if;
	end process output_reg;
		
end behavioral;
