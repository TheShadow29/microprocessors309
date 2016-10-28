library ieee;
use ieee.std_logic_1164.all;

package all_components is

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
			--prog_en,test_en: in std_logic;
			--prog_addr: in std_logic_vector(15 downto 0);
			--prog_data_w: in std_logic_vector(15 downto 0);
			--prog_data_r: out std_logic_vector(15 downto 0);
			
			not_start, clk_50, not_reset: in std_logic;
			done: out std_logic
			--op_code1: out std_logic_vector(3 downto 0);
			--mem_data_r1,mem_data_w1,mem_addr1,ir_dout1 : out std_logic_vector(15 downto 0)
		);
	end component iitb_risc;
	
	component ram_internal is
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
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
		test_en: in std_logic;
		prog_addr: in std_logic_vector(15 downto 0);
		--prog_data_w: in std_logic_vector(15 downto 0);
		prog_data_r: out std_logic_vector(15 downto 0);
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
		
		--mem_data_r1,mem_data_w1,mem_addr1,ir_dout1 : out std_logic_vector(15 downto 0)
	);
	end component;
	component ram2_inst is
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			wren		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	end component;

end all_components;