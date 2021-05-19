LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity ram_infer IS
port
(
	clk           : in  std_logic;
	data          : in  std_logic_vector (31 DOWNTO 0);
	write_address : in  integer RANGE 0 to 31;
	read_address  : in  integer RANGE 0 to 31;
	we            : in  std_logic;
	q             : out std_logic_vector (31 DOWNTO 0)
);
end ram_infer;

architecture rtl OF ram_infer IS
	TYPE mem IS ARRAY(0 TO 31) OF std_logic_vector(31 DOWNTO 0);
	SIGNAL ram_block : mem;
begin

	write:PROCESS (clk)
	begin
		if (clk'event AND clk = '1') THEN
			if (we = '1') THEN
				ram_block(write_address) <= data;
			end if;
		end if;
	end PROCESS write;
	
	q <= ram_block(read_address); -- READ

end rtl;