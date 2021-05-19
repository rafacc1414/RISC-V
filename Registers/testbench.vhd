-- Code your testbench here
library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use std.env.all;
use work.register_pkg.all;

entity testbench is
end entity testbench;

architecture tb of testbench is

  signal clk  : std_logic := '0';

  ---------------------------------------------
  ---------------- Flip-Flop D-----------------
  signal D    : std_logic := '0';		-- in
  signal E    : std_logic := '0';		-- in
  signal Q    : std_logic;				  -- out
  ---------------------------------------------
  
  
  ---------------------------------------------
  ----------------RISCV_Register---------------
  signal D_r    : std_logic_vector(32-1 downto 0):= x"00000001";	-- in
  signal E_r    : std_logic := '0';									              -- in
  signal Q_r    : std_logic_vector(32-1 downto 0);					      -- out
  ---------------------------------------------
  
  
  ---------------------------------------------
  ----------------RISCV_Register_File----------
  signal we		    : std_logic:='1';						                -- in we = Write enable
            
  signal rs1,rs2  : std_logic_vector(5-1 downto 0):= "00000";	-- in rs = Read Selection	    		
  signal ws	    	: std_logic_vector(5-1 downto 0);          	-- in ws = Write Selection
			
  signal wd		    : std_logic_vector(32-1 downto 0);		      -- in wd = Write Data
            
  signal rd1,rd2  : std_logic_vector(32-1 downto 0);	        -- out rd = Read Data
  ---------------------------------------------
  
  
  signal done         : boolean := false;
  constant CLK_PERIOD : time := 1 ns; 
    
begin

  d1: FF_D
  port map(clk=>clk, D =>D, E=>E, Q=>Q); 
    
  R0: RISCV_Register
  port map(clk=>clk, D =>D_r, E=>E_r, Q=>Q_r); 
  
  R_File: RISCV_Register_file
  port map(clk=>clk, we =>we, rs1=>rs1, rs2=>rs2, ws=>ws, wd=>wd, rd1=>rd1, rd2=>rd2); 
  
  
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
    -----------------Inputs SIMULATION--------------------------
    for i in 0 to 2 loop
      D <= '1';
      wait for CLK_PERIOD;

      E <= '1';
      wait for CLK_PERIOD;

      D <= '0';
      wait for CLK_PERIOD;

      E <= '0';
      wait for CLK_PERIOD;
    end loop;
    
    
    ------------------------------------------------------------
    -----------------Inputs RISCV_Register SIMULATION-----------
    -- Uncomment to simulate the case we write from x"00000000" to x"FFFFFFFF"    
    /*
    for i in 0 to 16 loop
      D_r <= std_logic_vector(unsigned(D_r) + 1);
      wait for CLK_PERIOD;

      E_r <= '1';
      wait for CLK_PERIOD;

      D_r <= std_logic_vector(unsigned(D_r) + 1);
      wait for CLK_PERIOD;

      E_r <= '0';
      wait for CLK_PERIOD;
    end loop;
    */
    
    -- Uncomment the next part in case you want to simulate de case when goes from x"FFFFFFFF" to x"00000000"
    /* 
    for i in 0 to 16 loop
      D_r <= std_logic_vector(unsigned(D_r) - 1);
      wait for CLK_PERIOD;

      E_r <= '1';
      wait for CLK_PERIOD;

      D_r <= std_logic_vector(unsigned(D_r) - 1);
      wait for CLK_PERIOD;

      E_r <= '0';
      wait for CLK_PERIOD;
    end loop;
    */      
    ------------------------------------------------------------
    -----------------Inputs RISCV_Register_file SIMULATION------
    for i in 0 to 5 loop
      rs1 <= "00100"; 
      rs2<="01000";
      wait for CLK_PERIOD;
		
      ws <= "01000";  
      wd <=x"FFFFFFFF";
      wait for CLK_PERIOD;

      rs1<="01000";
      rs2 <= "00100";
      wait for CLK_PERIOD;
      
      rs1<="01100";
      ws <= "01100";  
      wd <=x"FFFFFF00";
      wait for CLK_PERIOD;

      we <= not(we);
    end loop; 
    
    done <= true;
    report "All DONE";
    wait for CLK_PERIOD;   
    
    finish;
  end process;
  
end architecture tb;
