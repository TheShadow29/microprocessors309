library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
use work.all_components.all;	

entity TestRF is
end entity;
architecture Behave of TestRF is
  
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

  signal data1,data2,data3 : std_logic_vector(15 downto 0);
  signal addr1,addr2,addr3 : std_logic_vector(2 downto 0);
  signal rw : std_logic;
  signal clk : std_logic := '0';
begin
    clk <= not clk after 5 ns; -- assume 10ns clock.

  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "tracefile_rf.txt";
    FILE OUTFILE: text  open write_mode is "outputs.txt";

    ---------------------------------------------------
    -- edit the next two lines to customize
    variable input_rw: bit;
    variable input_addr1: bit_vector (2 downto 0);
    variable input_addr2: bit_vector (2 downto 0);
    variable input_addr3: bit_vector (2 downto 0);
    variable input_data3: bit_vector (15 downto 0);
    variable output_data1: bit_vector (15 downto 0);
    variable output_data2: bit_vector (15 downto 0);
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
          read (INPUT_LINE, input_addr1);
          read (INPUT_LINE, input_addr2);
          read (INPUT_LINE, input_addr3);
          read (INPUT_LINE, output_data1);
          read (INPUT_LINE, output_data2);
          read (INPUT_LINE, input_data3);

          --------------------------------------
          -- from input-vector to DUT inputs

        rw <= to_std_logic(input_rw);
        for i in 0 to 2 loop
            addr1(i) <= to_std_logic(input_addr1(i));
            addr2(i) <= to_std_logic(input_addr2(i));
            addr3(i) <= to_std_logic(input_addr3(i));
        end loop;
        for i in 0 to 15 loop
            data3(i) <= to_std_logic(input_data3(i));
        end loop;
          --------------------------------------


	  -- let circuit respond.
          wait for 5 ns;

          --------------------------------------
	  -- check outputs.
        if (input_rw /= '1') then
            for i in 0 to 15 loop
              if (data1(i) /= to_std_logic(output_data1(i))) then
                     write(OUTPUT_LINE,to_string("ERROR: in Data 1, line "));
                     write(OUTPUT_LINE, i);
                 write(OUTPUT_LINE, LINE_COUNT);
                     writeline(OUTFILE, OUTPUT_LINE);
                     err_flag := true;
              end if;
              if (data2(i) /= to_std_logic(output_data2(i))) then
                     write(OUTPUT_LINE,to_string("ERROR: in Data 2, line "));
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

  dut : RegFile port map (D1=>data1,D2=>data2,D3=>data3,A1=>addr1,A2=>addr2,A3=>addr3,clk=>clk,wr=>rw);

end Behave;
