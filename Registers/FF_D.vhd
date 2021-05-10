-----------------------------------
-- Model of a simple D Flip-Flop --
-----------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity

entity FF_D is
port (  
	CLK : in  std_logic;
	D   : in  std_logic;
	E   : in  std_logic; -- enable
	Q   : out std_logic
);
end FF_D;

-- architecture
architecture behav of FF_D is
signal S : std_logic:= '0'; -- Intermidiate Signal

begin
	dff: process(CLK)
	begin
		if (rising_edge(CLK)) then
			if(E = '1') then
				S <= D;
			else
				S <= S;
			end if;
		end if;
	end process dff;

	Q <= S;

end behav;