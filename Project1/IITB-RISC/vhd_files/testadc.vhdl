library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
use work.all_components.all;	

entity Testbench is
end entity;
architecture Behave of Testbench is
  
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

  signal alui1,alui2,aluo : std_logic_vector(15 downto 0);
  signal aluc, alufc, alufz : std_logic;
begin
  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "tracefile_adc.txt";
    FILE OUTFILE: text  open write_mode is "outputs.txt";

    ---------------------------------------------------
    -- edit the next two lines to customize
    variable input_aluc: bit;
    variable input_alui1: bit_vector (15 downto 0);
    variable input_alui2: bit_vector (15 downto 0);
    variable output_aluo: bit_vector (15 downto 0);
    variable output_c: bit;
    variable output_z: bit;
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin
   
    while not endfile(INFILE) loop 
          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, input_aluc);  
          read (INPUT_LINE, input_alui1);
          read (INPUT_LINE, input_alui2);
          read (INPUT_LINE, output_aluo);
          read (INPUT_LINE, output_alufc);
          read (INPUT_LINE, output_alufz);

          --------------------------------------
          -- from input-vector to DUT inputs

        aluc <= to_std_logic(input_aluc);
        for i in 0 to 15 loop
            alui1(i) <= to_std_logic(input_alui1(i));
            alui2(i) <= to_std_logic(input_alui2(i));
        end loop;
          --------------------------------------


	  -- let circuit respond.
          wait for 5 ns;

          --------------------------------------
	  -- check outputs.
        for i in 0 to 15 loop
          if (aluo(i) /= to_std_logic(output_aluo(i))) then
                 write(OUTPUT_LINE,to_string("ERROR: in ALU Out, line "));
                 write(OUTPUT_LINE, i);
             write(OUTPUT_LINE, LINE_COUNT);
                 writeline(OUTFILE, OUTPUT_LINE);
                 err_flag := true;
              end if;
        end loop;
        if (alufc(i) /= to_std_logic(output_alufc(i))) then
            write(OUTPUT_LINE,to_string("ERROR: in ALU Carry, line "));
            write(OUTPUT_LINE, i);
            write(OUTPUT_LINE, LINE_COUNT);
            writeline(OUTFILE, OUTPUT_LINE);
            err_flag := true;
        end if;

        if (alufz(i) /= to_std_logic(output_alufz(i))) then
            write(OUTPUT_LINE,to_string("ERROR: in ALU Zero, line "));
            write(OUTPUT_LINE, i);
            write(OUTPUT_LINE, LINE_COUNT);
            writeline(OUTFILE, OUTPUT_LINE);
            err_flag := true;
        end if;
          --------------------------------------
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  end process;

  dut : alu port map (X=>alui1,Y=>alui2,out_p=>aluo,op_code=>aluc,C=>alufc,Z=>alufz);

end Behave;
