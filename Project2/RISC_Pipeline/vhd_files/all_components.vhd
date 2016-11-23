library ieee;
use ieee.std_logic_1164.all;

package all_components is
	component ForwardingUnit is
		port (
			Rsrc, Rmem, Rwb : in std_logic_vector(3 downto 0);
			NOPmem, NOPwb, LW : in std_logic;
			Idef, Imem, Iwb, Ipc : in std_logic_vector(15 downto 0);
			Fout : out std_logic_vector(15 downto 0);
			Stall : out std_logic
		);
	end component;
	
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
end package;