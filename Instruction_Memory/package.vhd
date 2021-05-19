library ieee;
use ieee.std_logic_1164.all;

package I_M is

component Instruction_Memory IS
port (
	ReadAddr    : in  std_logic_vector (3  downto 0); 
	Instruction : out std_logic_vector (31 downto 0)
);
end component Instruction_Memory;

end package I_M;