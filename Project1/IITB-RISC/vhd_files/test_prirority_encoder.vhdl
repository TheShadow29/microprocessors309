library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
use work.all_components.all;	

entity test_priority_encoder is
end entity;
architecture Behave of test_priority_encoder is
  
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

  signal inp : std_logic_vector(7 downto 0);
  signal outp : std_logic_vector(2 downto 0);
  signal n1 : std_logic;
begin
  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "tracefile_pe.txt";
    FILE OUTFILE: text  open write_mode is "outputs.txt";

    ---------------------------------------------------
    -- edit the next two lines to customize
    variable inp_bv: bit_vector(7 downto 0);
    variable outp_bv: bit_vector (2 downto 0);
    variable n1_b: bit;
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin
   
    while not endfile(INFILE) loop 
          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, inp_bv);  
          read (INPUT_LINE, outp_bv);
          read (INPUT_LINE, n1_b);

          --------------------------------------
          -- from input-vector to DUT inputs

        --n1 <= to_std_logic(n1_b);
        for i in 0 to 7 loop
        	inp(i) <= to_std_logic(inp_bv(i));
        end loop;
          --------------------------------------


	  -- let circuit respond.
          wait for 5 ns;

          --------------------------------------
	  -- check outputs.
        for i in 0 to 2 loop
          if (outp(i) /= to_std_logic(outp_bv(i))) then
                 write(OUTPUT_LINE,to_string("ERROR: in PE output, line "));
                 write(OUTPUT_LINE, i);
             write(OUTPUT_LINE, LINE_COUNT);
                 writeline(OUTFILE, OUTPUT_LINE);
                 err_flag := true;
              end if;
        end loop;
		if (n1 /= to_std_logic(n1_b)) then
			write(OUTPUT_LINE,to_string("ERROR: in PE N flag, line "));
			--write(OUTPUT_LINE, i);
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

  --dut : alu port map (X=>alui1,Y=>alui2,out_p=>aluo,op_code=>aluc,C=>alufc,Z=>alufz);
  dut : PriorityEncoder port map (x => inp, s => outp, N => n1);
end Behave;
