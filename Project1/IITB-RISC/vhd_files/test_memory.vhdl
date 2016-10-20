library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
use work.all_components.all;	

entity test_memory is
end entity;
architecture Behave of test_memory is
  
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

  signal data_out, data_in : std_logic_vector(15 downto 0);
  signal addr: std_logic_vector(15 downto 0);
  signal rw : std_logic;
  signal clk : std_logic := '0';
begin
    clk <= not clk after 5 ns; -- assume 10ns clock.

  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "tracefile_mem.txt";
    FILE OUTFILE: text  open write_mode is "outputs.txt";

    ---------------------------------------------------
    -- edit the next two lines to customize
    variable input_rw: bit;
    variable input_addr: bit_vector (7 downto 0);
    variable data_bv: bit_vector (15 downto 0);
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin
   
    wait until clk = '1';
    while not endfile(INFILE) loop 
        wait until clk = '0';
          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, input_rw);  
          read (INPUT_LINE, input_addr);
          read (INPUT_LINE, data_bv);

          --------------------------------------
          -- from input-vector to DUT inputs

        rw <= to_std_logic(input_rw);
        for i in 0 to 15 loop
            addr(i) <= to_std_logic(input_addr(i));
        end loop;
          --------------------------------------
      	if (input_rw /= '0') then
            for i in 0 to 15 loop
            	data_in(i) <= to_std_logic(data_bv(i));
            end loop;
        end if;

	  -- let circuit respond.
          wait for 5 ns;

          --------------------------------------
	  -- check outputs.
        if (input_rw /= '1') then
            for i in 0 to 15 loop
              if (data_out(i) /= to_std_logic(data_bv(i))) then
                     write(OUTPUT_LINE,to_string("ERROR: in Data , line "));
                     write(OUTPUT_LINE, i);
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

  --dut : RegFile port map (D1=>data1,D2=>data2,D3=>data3,A1=>addr1,A2=>addr2,A3=>addr3,clk=>clk,wr=>rw);
  dut : memory_model port map (clk => clk, enable => '1', address => addr, datain => data_in, dataout => data_out, rw => rw);
end Behave;
