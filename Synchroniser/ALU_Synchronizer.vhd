-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_synchroniser is
port (  
	CLK           : in  std_logic;
	rd1_in        : in  std_logic;
	rd2_in        : in  std_logic;
	f3_in         : in  std_logic;
	f7_in         : in  std_logic;
	read_validity : in  std_logic;
	rd1_out       : out std_logic;
	rd2_out       : out std_logic;
	f3_out        : out std_logic;
	f7_out        : out std_logic
);
end ALU_synchroniser;

-- architecture
architecture rtl of ALU_synchroniser is

signal rd1_aux, rd2_aux     : std_logic;
signal f3_aux               : std_logic;
signal f7_aux               : std_logic;
	   
begin

sync_proc : process (read_validity)

begin
	if (rising_edge(read_validity)) then
		rd1_aux <= rd1_in;
		rd2_aux <= rd2_in;
		f3_aux  <= f3_in;
		f7_aux  <= f7_in;
	end if;

end process sync_proc;
	
output_reg: process(CLK)
begin
	if (falling_edge(CLK)) then
	   rd1_out <= rd1_aux;
	   rd2_out <= rd2_aux; 
	   f3_out  <= f3_aux;
	   f7_out  <= f7_aux;
	end if;
end process output_reg;
  
end rtl;