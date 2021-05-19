library ieee;
use ieee.std_logic_1164.all;

package DATA_MEMORY is

component ram_infer IS
port
(
	clk           : in  std_logic;
	data          : in  std_logic_vector (31 DOWNTO 0);
	write_address : in  integer RANGE 0 to 31;
	read_address  : in  integer RANGE 0 to 31;
	we            : in  std_logic;
	q             : out std_logic_vector (31 DOWNTO 0)
);
end component ram_infer;

end package DATA_MEMORY;