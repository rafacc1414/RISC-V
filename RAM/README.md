# RAM Implementation
 The file which contains the RAM implementation is called "design.vhd".

 Our RAM entity contains these Inputs/Outputs signals:
-      clk				: 	IN   std_logic;
-      data				:  	IN   std_logic_vector (31 DOWNTO 0);
-      write_address	:  	IN   integer RANGE 0 to 31;
-      read_address	    :   IN   integer RANGE 0 to 31;
-      we				:   IN   std_logic;
-      q				:   OUT  std_logic_vector (31 DOWNTO 0)

The desing of the entity is what appears in the image: 
()[https://raw.githubusercontent.com/rafacc1414/RISC-V/master/Images/RAM_entity.png]

We have to take into account that we use an intenger from 0 to 31 to select the address. It means the same as declaring a std_logic_vector(4 DOWNTO 0). They just differ in the type.


 