LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY ram_infer IS
   PORT
   (
      clk				: 	   IN   std_logic;
      data				:  	IN   std_logic_vector (31 DOWNTO 0);
      write_address	:  	IN   integer RANGE 0 to 31;
      read_address	:     IN   integer RANGE 0 to 31;
      we				   :     IN   std_logic;
      q					:     OUT  std_logic_vector (31 DOWNTO 0)
   );
END ram_infer;
ARCHITECTURE rtl OF ram_infer IS
   TYPE mem IS ARRAY(0 TO 31) OF std_logic_vector(31 DOWNTO 0);
   SIGNAL ram_block : mem;
BEGIN

write:PROCESS (clk)
   BEGIN
      IF (clk'event AND clk = '1') THEN
         IF (we = '1') THEN
            ram_block(write_address) <= data;
         END IF;
      END IF;
   END PROCESS write;
   
q <= ram_block(read_address); -- READ
   
END rtl;