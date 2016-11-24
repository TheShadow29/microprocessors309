library ieee;
use ieee.std_logic_1164.all;

package all_components is
	component DataRegister is
		--n bit register
		port (Din: in std_logic_vector;
				Dout: out std_logic_vector;
				clk, enable: in std_logic);
	end component;
	
	component Incrementer is
		 port(
			  x: in std_logic_vector(15 downto 0);
			  z: out std_logic_vector(15 downto 0);
		 );
	end component;
	
	component PriorityEncoder is
		port ( x : in std_logic_vector(7 downto 0) ;
				 S : out std_logic_vector(2 downto 0);
				 N : out std_logic;
				 Tn: out std_logic_vector(7 downto 0)
			) ;
	end PriorityEncoder ;
	
	component program_rom is
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	end component;
	
	component data_ram IS
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			wren		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END data_ram;
	
	component ForwardingUnit is
		port (
			Rsrc, Rmem, Rwb : in std_logic_vector(3 downto 0);
			NOPmem, NOPwb, LW : in std_logic;
			Idef, Imem, Iwb, Ipc : in std_logic_vector(15 downto 0);
			Fout : out std_logic_vector(15 downto 0);
			Stall : out std_logic
		);
	end component;
	
	component RegFile is
		port(
			D1,D2: out std_logic_vector(15 downto 0);
			A1,A2,A3 :in std_logic_vector(2 downto 0);
			D3, PC:in std_logic_vector(15 downto 0);
			clk, WR, R7upd: in std_logic
		 );
	end component RegFile;
	
	component alu is
		port
		(
			X, Y : in std_logic_vector(15 downto 0);
			out_p : out std_logic_vector(15 downto 0);
			C, Z : out std_logic;
			op_code : in std_logic;
			do_xor : in std_logic
		);
	end alu;
	
	component FlagForwardingUnit is
		port (
			Flag : in std_logic_vector(1 downto 0);
			Cmem, Zmem, NOPmem : in std_logic;
			
			ForwardOut : out std_logic
		);
	end component;
	
	component instruction_decoder is
	port
	(
		ir_out : in std_logic_vector(15 downto 0);
		op_code : out std_logic_vector(3 downto 0);
		condition_code : out std_logic_vector(1 downto 0);
		ra : out std_logic_vector(2 downto 0);
		rb : out std_logic_vector(2 downto 0);
		rc : out std_logic_vector(2 downto 0);
		nine_bit_high : out std_logic_vector(15 downto 0);
		sign_ext_imm : out std_logic_vector(15 downto 0);
		eight_bit_lm_sm : out std_logic_vector(7 downto 0);
		is_lhi : out std_logic;
		is_jal : out std_logic;
		is_lm_sm : out std_logic
	);
	end component;
	component control_decoder is
		port 
		(
			op_code : in std_logic_vector(3 downto 0);
			condition_code : in std_logic_vector(1 downto 0);
			nop_code : in std_logic;
			--RR controls
			is_jlr : out std_logic;
			a2c : out std_logic_vector(1 downto 0);
			a1c : out std_logic;
			rdc : out std_logic_vector(1 downto 0);
			is_lm_sm : out std_logic;
			dmem_c : out std_logic;
			--Exec controls
			is_beq : out std_logic;
			alu_c : out std_logic_vector(1 downto 0);
			flag_c : out std_logic_vector(1 downto 0); -- "00" for nothing, "10" C forwarding "01" Z forwarding "11" for both
			cflag_c : out std_logic;
			zflag_c : out std_logic;
			imm : out std_logic;
			pc1 : out std_logic;
			is_lhi : out std_logic;
			--Mem controls
			is_lw : out std_logic;
			mem_w_c : out std_logic;
			mem_r_c : out std_logic;
			out_c : out std_logic;
			z_c : out std_logic;
			--write controls
			wen : out std_logic;
			cen : out std_logic;
			zen : out std_logic
		);
	end component;
	
	component ControlWord is
		port (
			cin: std_logic_vector;
			cout: std_logic_vector;
			nop: std_logic
		);
	end component ControlWord;

	component PCUpdate is
	   port (
			RD : in std_logic_vector(2 downto 0);
			WENin : in std_logic;
			
			WENout, R7upd, Stall : out std_logic;
		);
	end component;
end package;