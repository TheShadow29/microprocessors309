library ieee;
use ieee.std_logic_1164.all;

entity instruction_decoder is
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
end entity;

architecture decoder of instruction_decoder is
	signal nine_bit_high_s, nine_bit_imm_s, six_bit_imm_s : std_logic_vector(15 downto 0) := (others=>'0');
	signal op_code_s : std_logic_vector(3 downto 0);
begin
	op_code_s <= ir_out(15 downto 12);
	op_code <= op_code_s;
	condition_code <= ir_out(1 downto 0);
	ra<=ir_out(11 downto 9);
	rb<=ir_out(8 downto 6);
	rc<=ir_out(5 downto 3);
	nine_bit_high_s(15 downto 7) <= ir_out(8 downto 0);
	nine_bit_imm_s(8 downto 0) <= ir_out(8 downto 0);
	six_bit_imm_s(5 downto 0) <= ir_out(5 downto 0);
	
	nine_bit_high <= nine_bit_high_s;
	nine_bit_imm <= nine_bit_imm_s;
	six_bit_imm <= six_bit_imm_s;
	process (clk, op_code_s)
		variable is_jal_var : std_logic;
		variable is_lhi_var : std_logic;
		variable is_lm_sm_var : std_logic;
		begin
			is_jal_var := '0';
			is_lhi_var := '0';
			is_lm_sm_var := '0';
			if (op_code_s = "1000") then --jal
				is_jal_var := '1';
			elsif (op_code_s = "0011") then --lhi
				is_lhi_var := '1';
			elsif (op_code_s = "0110" or op_code_s = "0111") then --lm/sm
				is_lm_sm_var := '1';
			end if;
			is_jal <= is_jal_var;
			is_lhi <= is_lhi_var;
			is_lm_sm <= is_lm_sm_var;		
			
	end process;
end architecture;