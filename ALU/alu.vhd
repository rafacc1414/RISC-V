-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is

generic (N: natural :=32);

port
(
	CLK      : in  std_logic;
	A        : in  std_logic_vector (N-1 downto 0);
	B        : in  std_logic_vector (N-1 downto 0);
	Funct_3  : in  std_logic_vector (2  downto 0);
	Funct_7  : in  std_logic_vector (6  downto 0);
	Result   : out std_logic_vector (N-1 downto 0);
	Zero     : out std_logic;
	Sign     : out std_logic;
	Overflow : out std_logic
);
end entity ALU;

architecture behavioral of ALU is
	
	signal R_Async                   : std_logic_vector (N-1 downto 0) := (others => '0');
	signal Z_Async, S_Async, O_Async : std_logic := '0';
	
	type Op_Type is (ADD, SUB, SLLop, SLT, SLTU, XORop, SRLop, SRAop, ORop, ANDop, ERROR);
	signal Operation : Op_Type;
	
	constant UPPER_LIMIT : integer  := (2**(N-1));
	constant LOWER_LIMIT : integer  := -(2**N-1); 
		
begin
	
	op_type_process : process (Funct_3, Funct_7)
	begin
		case Funct_7 is
			when "0000000" =>
				case Funct_3 is
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
				case Funct_3 is
					when "000" => Operation <= SUB;
					when "101" => Operation <= SRAop;
					when others => Operation <= ERROR;
				end case;
			when others => Operation <= ERROR;
		end case;
	end process op_type_process;
	
	op_calc_process : process (Operation, A, B)
	-- IMPORTANT : We must use variables if its desired that values in the process change inmediately
	-- For using the value in following sentences of the process
	variable R_Aux            : integer  := 0;
	variable A_Aux, B_Aux     : integer  := 0;
	variable A_Aux_U, B_Aux_U : unsigned (N-1 downto 0)  := (others => '0');
	begin
		A_Aux   := to_integer (signed (A));
		B_Aux   := to_integer (signed (B));
		A_Aux_U := unsigned(A);
		B_Aux_U := unsigned(B);
		case Operation is
			when ADD => 
				R_Aux   := A_Aux + B_Aux;
				R_async <= std_logic_vector(to_signed(R_Aux, R_async'length));
			when SUB =>
				R_Aux   := A_Aux - B_Aux;
				R_async <= std_logic_vector(to_signed(R_Aux, R_async'length));
			when SLLop =>
				R_Async <= A SLL B_Aux;
			when SLT =>
				R_Async <= (others => '0');
				if (A_Aux < B_Aux) then
					R_Async (0) <= '1';
				end if;
			when SLTU =>
				R_Async <= (others => '0');
				if (A_Aux_U < B_Aux_U) then
					R_Async (0) <= '1';
				end if;
			when XORop =>
				R_Async <= A XOR B;
			when SRLop =>
				R_Async <= A SRL B_Aux;
			when SRAop =>
				R_Async <= std_logic_vector (A_Aux_U SRA B_Aux);
			when ORop =>
				R_Async <= A OR B;
			when ANDop =>
				R_Async <= A AND B;
			when others =>
				R_Async <= (others => '0');
		end case;
		Z_async <= '0';
		if R_Aux >= UPPER_LIMIT then
			O_Async <= '1';
			S_Async <= '0';
		elsif R_Aux < LOWER_LIMIT then
			O_Async <= '1';
			S_Async <= '1';
		elsif R_Aux < 0 then
			O_Async <= '0';
			S_Async <= '1';
		elsif R_Aux > 0 then
			O_Async <= '0';
			S_Async <= '0';
		else
			O_Async <= '0';
			S_Async <= '0';
			Z_Async <= '1';
		end if;
	end process op_calc_process;

	-- FF at the exit for getting sure that the output is correct
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