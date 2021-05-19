-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.I_M.all;

entity tb_Instruction_Memory is
end tb_Instruction_Memory;

architecture behavior of tb_Instruction_Memory is

	signal tb_ReadAddr : std_logic_vector (3 downto 0):="0000";    
	signal tb_Instruction : std_logic_vector (31 downto 0);   

begin 
	
	u1_test : Instruction_Memory 
	port map (
		ReadAddr    => tb_ReadAddr,
		Instruction => tb_Instruction
	);

	stim_proc : process
	begin 
		for I in 0 to 15 loop
			tb_ReadAddr <= std_logic_vector(to_unsigned(I, tb_ReadAddr'length));
			wait for 3 ns;
		end loop;
		
		assert false
			report "End"
			severity failure;
	end process;
END;