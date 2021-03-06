-- Code your testbench here
library ieee;
use ieee.std_logic_1164.all;
use std.env.all;
use work.DATA_MEMORY.all;



entity testbench is
end entity testbench;

architecture tb of testbench is

  signal clk  : std_logic := '0'; 
  
  ---------------------------------------------
  ----------------RISCV_Register_File----------
  signal    data				:  	   std_logic_vector (31 DOWNTO 0);
  signal    write_address		:  	   integer RANGE 0 to 31;
  signal    read_address		:      integer RANGE 0 to 31;
  signal    we					:      std_logic := '1';
  signal    q					:      std_logic_vector (31 DOWNTO 0);
  ---------------------------------------------
  
  
  signal done : boolean := false;
  constant CLK_PERIOD : time := 1 ns; 
    
begin

  RAM: ram_infer
  port map(clk=>clk, data =>data, write_address=>write_address ,read_address => read_address,we=>we, q=>q); 
    
    -- Clock Generator Process--
  clk_gen: process(clk)
  begin
    if not done then
      clk <= not clk after CLK_PERIOD/2;
    else
      clk <= '0';
    end if;
  end process clk_gen;
  
  -- Stimulus Generator Process--
  stim_gen: process
  begin
    ------------------------------------------------------------
    -----------------Inputs RISCV_Register_file SIMULATION------
    --(32*32 - 1)
    for i in 0 to 5 loop
	  data <= x"FFFFFFFF";
      write_address<= 5;
      read_address<=0;
      wait for 3*CLK_PERIOD;
		
      read_address<=5; 
      wait for 3*CLK_PERIOD;

	  data <= x"FFFF000F";
      write_address<= 1;
      read_address<=1;
      wait for 3*CLK_PERIOD;
      
      read_address<=8;
      we <= not(we);
      data <= x"F00A000F";
      write_address<= 1;
      wait for 3*CLK_PERIOD;
    end loop;   
    
    done <= true;
    report "All DONE";
    wait for CLK_PERIOD;   
    
    finish;
  end process;
  
end architecture tb;



