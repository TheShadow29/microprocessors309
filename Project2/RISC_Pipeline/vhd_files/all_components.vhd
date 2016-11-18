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
		clk : in std_logic;
		ir_out : in std_logic_vector(15 downto 0);
		op_code : out std_logic_vector(3 downto 0);
		condition_code : out std_logic_vector(1 downto 0);
		ra : out std_logic_vector(2 downto 0);
		rb : out std_logic_vector(2 downto 0);
		rc : out std_logic_vector(2 downto 0);
		nine_bit_high : out std_logic_vector(15 downto 0);
		nine_bit_imm : out std_logic_vector(15 downto 0);
		six_bit_imm : out std_logic_vector(15 downto 0);
		is_lhi : out std_logic;
		is_jal : out std_logic;
		is_lm_sm : out std_logic
	);
	end component;
end package;