library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
use work.all_components.all;	

entity test_pipeline is
end entity;
architecture Behave of test_pipeline is
  
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

  signal clk : std_logic := '0';
  signal instr_start : std_logic := '0';
  signal instr_done : std_logic := '0';
  signal prog_reset : std_logic := '0';
  signal inp_addr : std_logic_vector(15 downto 0);
  
	constant one16 : bit_vector(15 downto 0) := (others => '1');
	constant highZ : std_logic_vector(15 downto 0) := (others => 'Z');
begin

    clk <= not clk after 10 ns; -- assume 10ns clock.

	process 
		variable err_flag : boolean := false;
		variable I : integer := 0;
		variable pc_count_var : integer := 0;
		File INFILE: text open read_mode is "trace_pipeline.txt";
		FILE OUTFILE: text open write_mode is "outputs.txt";

--		---------------------------------------------------
--		-- edit the next two lines to customize
--		variable input_state, mode: bit := '0';
		variable input_addr_bv: bit_vector (15 downto 0);
--		variable input_data: bit_vector (15 downto 0);
--		----------------------------------------------------
		variable INPUT_LINE: Line;
		variable OUTPUT_LINE: Line;
--		variable LINE_COUNT: integer := 0;

		begin
			--instr_start <= '0';
			--instr_done <= '0';
			prog_reset <= '1';
			wait until clk = '0';
			prog_reset<='0';
			wait for 3 ms;
			--while (I < 1) loop
			--	--instr_start <= '1';
			--	--wait until clk = '1';
			--	--instr_start <= '0';
			--	--readline(INFILE,INPUT_LINE);
			--	--read(INPUT_LINE,inp_addr);
			--	--if(inp_addr_bv = one16)then
			--	--	exit;
			--	--end if;
			--	--wait until instr_done = '1';
			--	--for k in 0 to 15 loop
			--	--	inp_addr(i) <= inp_addr_bv(i);
			--	--end loop;
				
			--	--pc_count_var := pc_count_var + 1;
				
			--	--write(OUTPUT_LINE,to_string("Instruction "));
			--	--write(OUTPUT_LINE,pc_count_var);
			--	--write(OUTPUT_LINE," ");
			--	--write(OUTPUT_LINE,inp_addr);
			--	--write(OUTPUT_LINE," exec done");
			--	--writeline(OUTFILE,OUTPUT_LINE);
			--end loop;
				
		end process;
dut : RISC_Pipeline port map (clk => clk, reset => prog_reset, start => instr_start, done => instr_done);

end Behave;
