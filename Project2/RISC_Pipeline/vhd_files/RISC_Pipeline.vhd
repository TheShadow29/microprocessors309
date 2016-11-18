library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all_components.all;


entity RISC_Pipeline is
	port
	(
		clk, reset, start : in std_logic;
		done : out std_logic
	);
end entity;

architecture pipe of RISC_Pipeline is
		signal ir_out : std_logic_vector(15 downto 0);
		signal op_code : std_logic_vector(3 downto 0);
		signal condition_code : std_logic_vector(1 downto 0);
		signal ra : std_logic_vector(2 downto 0);
		signal rb : std_logic_vector(2 downto 0);
		signal rc : std_logic_vector(2 downto 0);
		signal nine_bit_high : std_logic_vector(15 downto 0);
		signal nine_bit_imm : std_logic_vector(15 downto 0);
		signal six_bit_imm : std_logic_vector(15 downto 0);
		signal is_lhi : std_logic;
		signal is_jal : std_logic;
		signal is_lm_sm : std_logic;
begin
	id : instruction_decoder port map 
				(
				clk=> clk,
				ir_out => ir_out,
				op_code => op_code,
				condition_code => condition_code,
				ra => ra,
				rb => rb,
				rc => rc,
				nine_bit_high =>nine_bit_high, 
				nine_bit_imm => nine_bit_imm,
				six_bit_imm =>six_bit_imm,
				is_lhi =>is_lhi,
				is_jal =>is_jal,
				is_lm_sm =>is_lm_sm
				);
end architecture;
