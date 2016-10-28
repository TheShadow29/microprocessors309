library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
use work.all_components.all;	

entity TestProcessor is
end entity;
architecture Behave of TestProcessor is
  
  function to_std_logic(x: bit) return std_logic is
      variable ret_val: std_logic;
  begin  
    
      if (x = '1') then
        ret_val := '1';
      else 	
        ret_val := '0';
      end if;
    
      return(ret_val);
  end to_std_logic;


  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin  
      ret_val := lx;
      return(ret_val);
  end to_string;

  signal prog_addr,prog_data_w,prog_data_r,prog_data, 
  mem_addr1,mem_data_r1,mem_data_w1,ir_dout1 : std_logic_vector(15 downto 0);
  signal prog_en,test_en,proc_start,proc_done,proc_reset : std_logic;
  signal clk : std_logic := '0';
  
  
	constant highZ : std_logic_vector(15 downto 0) := (others => 'Z');
begin
    clk <= not clk after 10 ns; -- assume 10ns clock.

  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "trace_processor.txt";
    FILE OUTFILE: text  open write_mode is "outputs.txt";

    ---------------------------------------------------
    -- edit the next two lines to customize
    variable input_state, mode: bit := '0';
    variable input_addr: bit_vector (15 downto 0);
    variable input_data: bit_vector (15 downto 0);
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin
    proc_start <= '0';
	 prog_en <= '1';
	 test_en <= '0';

    proc_reset<='1';
    wait until clk = '0';
    proc_reset<='0';

    while not endfile(INFILE) loop 
        wait until clk = '0';
          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, input_state);
          read (INPUT_LINE, input_addr);
          read (INPUT_LINE, input_data);

          --------------------------------------
          -- from input-vector to DUT inputs

        for i in 0 to 15 loop
            prog_addr(i) <= to_std_logic(input_addr(i));
        end loop;
          --------------------------------------
          --------------------------------------
	  -- check outputs.
        if input_state = '1' and mode = '0'
        then
				prog_en <= '0';
				proc_start <= '1';
				wait until clk = '0';
				proc_start <= '0';
            wait until proc_done = '1';
				mode := '1' ;
        end if;

        if mode = '0'
        then
            for i in 0 to 15 loop
                prog_data_w(i) <= to_std_logic(input_data(i));
            end loop;
        end if;

        if mode = '1'
        then
				test_en <= '1';
				prog_data_w <= highZ;
				wait until clk = '0';
            for i in 0 to 15 loop
              if (prog_data_r(i) /= to_std_logic(input_data(i))) then
                     write(OUTPUT_LINE,to_string("ERROR: in Checking Data, line "));
                     --write(OUTPUT_LINE, i);
							write(OUTPUT_LINE, LINE_COUNT);
                     writeline(OUTFILE, OUTPUT_LINE);
                     err_flag := true;
              end if;
            end loop;
        end if;
          --------------------------------------
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  end process;

--  prog_data <= prog_data_w;
--  prog_data_r <= prog_data;
  dut : iitb_risc port map (prog_en=>prog_en,test_en=>test_en,prog_addr=>prog_addr,
									 prog_data_w=>prog_data_w,prog_data_r=>prog_data_r,
                            start=>proc_start, done=>proc_done, clk=>clk, reset=>proc_reset, 
									 mem_addr1=>mem_addr1, mem_data_r1=>mem_data_r1, mem_data_w1=> mem_data_w1
									 ,ir_dout1=>ir_dout1);

end Behave;
