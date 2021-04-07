library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Instruction_Memory is
port 
(
	ReadAddr : in std_logic_vector (3 downto 0);
	Instruction : out std_logic_vector (31 downto 0)
);
end Instruction_Memory;

architecture Ins_Mem of Instruction_Memory is 
-- definimos la memoria como un vector de tamaño 16 de vectores, donde los vectores serían las instrucciones. Es decir una memoria donde caben 16 instrucciones las cuales tienen un tamaño de 32.
	type RAM_16x32 is array (0 to 15) of std_logic_vector(31 downto 0);
	
	signal IM : RAm_16x32 := (
	
	--Explicacion instrucciones R
	-- add $t2, $t1, $t0 la t indica temporales, estos valores son en decimal
	-- t2 = 10 convertimos a binario 01010
	-- t1 = 9  convertimos a binario 01001
	-- t0 = 8  convertimos a binario 01000
	-- las instrucctiones R tienen todas 00000 en el campo opcode
	-- la instruccion add tiene el valor de campo funct 100000
	-- las instruccion quedaría como 
	-- 000000 01001 01000 01010 00000 100000 
	-- convertimos de binario a hexadecimal y nos queda
								
								x"01285020",  -- 0x0040 0000: add $t2, $t1, $t0
								x"01285024",  -- 0x0040 0004: and $t2, $t1, $t0
								x"01285022",  -- 0x0040 0008: sub $t2, $t1, $t0
								x"01285025",  -- 0x0040 000C: or $t2, $t1, $t0
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000"
							 );
begin 
	Instruction <=  IM(to_integer(unsigned(ReadAddr)));
end Ins_Mem;