library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
use work.all_components.all;	

entity Testbench is
end entity;
architecture Behave of Testbench is
  

  signal x0,x1,y: std_logic_vector(7 downto 0);
  signal opcode : std_logic_vector(1 downto 0);

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

begin
  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "TRACEFILEsmall.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";

    ---------------------------------------------------
    -- edit the next two lines to customize
    variable input_vector: bit_vector(1 downto 0);
    variable input_vector1: bit_vector ( 7 downto 0);
    variable input_vector2: bit_vector(7 downto 0);
    variable output_vector: bit_vector ( 7 downto 0);
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin
   
    while not endfile(INFILE) loop 
          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, input_vector);
	  read (INPUT_LINE, input_vector1);
	  read (INPUT_LINE, input_vector2);
          read (INPUT_LINE, output_vector);

          --------------------------------------
          -- from input-vector to DUT inputs
        for i in 0 to 1 loop
      opcode(i) <= to_std_logic(input_vector(i));
    end loop;
	for i in 0 to 7 loop
	x0(i) <= to_std_logic(input_vector1(i));
	end loop;

	for i in 0 to 7 loop
	x1(i) <= to_std_logic(input_vector2(i));
	end loop;
	  
          --------------------------------------


	  -- let circuit respond.
          wait for 5 ns;

          --------------------------------------
	  -- check outputs.
	for i in 0 to 7 loop
	  if (y(i) /= to_std_logic(output_vector(i))) then
             write(OUTPUT_LINE,to_string("ERROR: in s0, line "));
             write(OUTPUT_LINE, i);
	     write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
	end loop;
          --------------------------------------
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  end process;

end Behave;