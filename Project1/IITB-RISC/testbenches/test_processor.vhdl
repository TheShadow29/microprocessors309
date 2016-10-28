library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
--use work.all_components.all;	

entity TestProcessor is
end entity;
architecture Behave of TestProcessor is

		component mux2 is
		port 
		(
			A0,A1 : in std_logic_vector;
			s : in std_logic;
			D : out std_logic_vector
		);
	end component;
	
	component mux4 is
		port 
		(
			A0,A1,A2,A3 : in std_logic_vector;
			s : in std_logic_vector(1 downto 0);
			D : out std_logic_vector
		);
	end component;
	
	component mux8 is
		port 
		(
			A0,A1,A2,A3,A4,A5,A6,A7 : in std_logic_vector;
			s : in std_logic_vector(2 downto 0);
			D : out std_logic_vector
		);
	end component;
	
	component Adder is
		 port(
			  cin: in std_logic;
			  x, y: in std_logic_vector(15 downto 0);
			  z: out std_logic_vector(15 downto 0);
			  cout: out std_logic
		 );
	end component;
	
	component Decoder8 is
		port (
			A: in std_logic_vector(2 downto 0);
			OE: in std_logic;
			O: out std_logic_vector(7 downto 0)
		);
	end component Decoder8;
	
	component alu is
	port
	(
		X, Y : in std_logic_vector(15 downto 0);
		out_p : out std_logic_vector(15 downto 0);
		C, Z : out std_logic;
		op_code : in std_logic;
		do_xor : in std_logic
	);
	end component;
	
	component DataRegister is
		--n bit register
		port (Din: in std_logic_vector;
				Dout: out std_logic_vector;
				clk, enable: in std_logic);
	end component;
	
	component data_register_bin is
	port (Din: in std_logic;
	      Dout: out std_logic;
	      clk, enable: in std_logic);
	end component;
	
	component RegFile is
		port(
			D1,D2: out std_logic_vector(15 downto 0);
			A1,A2,A3 :in std_logic_vector(2 downto 0);
			D3 :in std_logic_vector(15 downto 0);
			clk, WR: in std_logic
		 );
	end component RegFile;
	
	component PriorityEncoder is
	port ( X : in std_logic_vector(7 downto 0) ;
		S : out std_logic_vector(2 downto 0);
	 N : out std_logic;
	 Tn: out std_logic_vector(7 downto 0)) ;
	end component;
	
	component iitb_risc is
		port (
			prog_en,test_en: in std_logic;
			prog_addr: in std_logic_vector(15 downto 0);
			prog_data: inout std_logic_vector(15 downto 0);
					
			start, clk, reset: in std_logic;
			done : out std_logic;
			op_code1 : out std_logic_vector(3 downto 0)
		);
	end component iitb_risc;
	
	component memory_model is
	  port (
		 clk   : in  std_logic;
		 rw : in std_logic;
		 address : in  std_logic_vector;
		 data  : inout  std_logic_vector
	  );
	end component;
	
	component control_path is
	port
	(
		alu_control : out std_logic;
		a1_mux_c : out std_logic_vector(1 downto 0);
		a2_mux_c : out std_logic;
		a3_mux_c : out std_logic_vector(2 downto 0);
		t1_mux_c : out std_logic;
		t2_mux_c : out std_logic_vector(2 downto 0);
		t3_w_c : out std_logic;
		d3_mux_c : out std_logic_vector(1 downto 0);
		a0_mux_c : out std_logic_vector(1 downto 0);
		ir_w_c : out std_logic;
		di_w_c : out std_logic;
		do_mux_c : out std_logic;
		do_w_c : out std_logic;
		tx_mux_c : out std_logic_vector(1 downto 0);
		do_xor_c : out std_logic;
		car_w_c : out std_logic;
		zer_w_c : out std_logic;
		uc_w_c : out std_logic;
		clk, reset : in std_logic;
		op_code : in std_logic_vector(3 downto 0);
		condition_code : in std_logic_vector(1 downto 0);
		V : in std_logic;
		carry_flag : in std_logic;
		zero_flag : in std_logic;
		start : in std_logic;
		done : out std_logic
	);
	end component;
	
	component data_path is
	port 
	(
		prog_en,test_en: in std_logic;
		prog_addr: in std_logic_vector(15 downto 0);
		prog_data: inout std_logic_vector(15 downto 0);
		a1_mux_c : in std_logic_vector(1 downto 0);
		a2_mux_c : in std_logic;
		a3_mux_c : in std_logic_vector(2 downto 0);
		t1_mux_c : in std_logic;
		t2_mux_c : in std_logic_vector(2 downto 0);
		t3_w_c : in std_logic;
		a0_mux_c : in std_logic_vector(1 downto 0);
		ir_w_c : in std_logic;
		di_w_c : in std_logic;
		do_mux_c : in std_logic;
		do_w_c : in std_logic;
		d3_mux_c : in std_logic_vector(1 downto 0);
		tx_mux_c : in std_logic_vector(1 downto 0);
		car_w_c : in std_logic;
		zer_w_c : in std_logic;
		do_xor_c : in std_logic;
		carry_flag : out std_logic;
		zero_flag : out std_logic;
		alu_op_code : in std_logic;
		clk, reset : in std_logic;
		uc_rw_c : in std_logic;
		op_code : out std_logic_vector(3 downto 0);
		condition_code : out std_logic_vector(1 downto 0);
		N : out std_logic
	);
	end component;
  
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

  signal prog_addr,prog_data_w,prog_data_r,prog_data : std_logic_vector(15 downto 0);
  signal prog_en,test_en,proc_start,proc_done,proc_reset : std_logic;
  signal clk : std_logic := '0';
  signal op_code1 : std_logic_vector(3 downto 0);
  
  
	constant highZ : std_logic_vector(15 downto 0) := (others => 'Z');
begin
    clk <= not clk after 20 ns; -- assume 10ns clock.

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

  prog_data <= prog_data_w;
  prog_data_r <= prog_data;
  dut : iitb_risc port map (prog_en=>prog_en,test_en=>test_en,prog_addr=>prog_addr,prog_data=>prog_data,
                            start=>proc_start, done=>proc_done, clk=>clk, reset=>proc_reset, op_code1 => op_code1);

end Behave;
