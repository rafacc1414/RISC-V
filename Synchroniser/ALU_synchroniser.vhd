-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_synchroniser is
       port (  
              CLK              : in  std_logic;
              rd1, rd2         : in  std_logic;		
              read_validity    : in  std_logic;
              
              rd1_out, rd2_out : out std_logic;
              en_out           : out std_logic
);
end ALU_synchroniser;

-- architecture
architecture rtl of ALU_synchroniser is

type state_type is (ST0,ST1);
signal PS,NS                : state_type;
signal  rd1_b, rd2_b, en    : std_logic;
signal read_v               : std_logic; --read validity store
       
begin

sync_proc: process(CLK,NS)
begin
	if (rising_edge(CLK)) then
       PS <= NS;
       rd1_b <= rd1; -- Store the value of rd1
       rd2_b <= rd2; -- Store the value of rd2
       read_v <= read_validity;
	end if;
end process sync_proc;

comb_proc: process(PS,rd1, rd2, read_v)
begin
	-- en_out: the Moore output
	en_out <= '0'; 
	case PS is
		when ST0 => -- items regarding state ST0
			en <= '0'; -- Moore output
			if ( read_v = '1' ) then NS <= ST1;
			else NS <= ST0;
			end if;
		when ST1 => -- items regarding state ST1
			 en <= '1'; -- Moore output
		     NS <= ST0; 
		end case;
end process comb_proc;

en_out  <= en;
rd1_out <= rd1_b;
rd2_out <= rd2_b;
  
end rtl;