library ieee;
use ieee.std_logic_1164.all;

package DATA_MEMORY is

component ram_infer IS
   PORT
   (
      clk				: 	IN   std_logic;
      data				:  	IN   std_logic_vector (31 DOWNTO 0);
      write_address		:  	IN   integer RANGE 0 to 31;
      read_address		:   IN   integer RANGE 0 to 31;
      we				:   IN   std_logic;
      q					:   OUT  std_logic_vector (31 DOWNTO 0)
   );
END component ram_infer;
    
    

end package DATA_MEMORY;