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
		signal sign_ext_imm : std_logic_vector(15 downto 0);
		signal eight_bit_lm_sm : std_logic_vector(7 downto 0);
		signal is_lhi_dc, is_jal, is_lm_sm_dc: std_logic;
		signal is_jlr, is_beq, is_lm_sm_rr, is_lhi_alu, is_lw, is_lm_sm_cd: std_logic;
		signal nop_code,mem_w_c, mem_r_c, out_c, wen: std_logic;
		signal a2c,rdc,alu_c, flag_c : std_logic_vector(1 downto 0);
		signal a1c, dmem_c, cflag_c, zflag_c, zen, cen, imm, pc1, z_c: std_logic;
begin
	id : instruction_decoder port map 
				(
				ir_out => ir_out,
				op_code => op_code,
				condition_code => condition_code,
				ra => ra,
				rb => rb,
				rc => rc,
				nine_bit_high =>nine_bit_high, 
				sign_ext_imm => sign_ext_imm,
				eight_bit_lm_sm => eight_bit_lm_sm,
				is_lhi =>is_lhi_dc,
				is_jal =>is_jal,
				is_lm_sm =>is_lm_sm_dc
				);
		cd : control_decoder port map
				(
					op_code => op_code,
					condition_code => condition_code,
					nop_code => nop_code,
					--RR controls
					is_jlr => is_jlr,
					a2c => a2c,
					a1c => a1c,
					rdc => rdc,
					is_lm_sm => is_lm_sm_cd,
					dmem_c => dmem_c,
					--Exec controls
					is_beq => is_beq,
					alu_c => alu_c,
					flag_c => flag_c, -- "00" for nothing, "10" C forwarding "01" Z forwarding "11" for both
					cflag_c => cflag_c,
					zflag_c => zflag_c,
					imm => imm,
					pc1 => pc1,
					is_lhi => is_lhi_alu,
					--Mem controls
					is_lw => is_lw,
					mem_w_c => mem_w_c,
					mem_r_c => mem_r_c,
					out_c => out_c,
					z_c => z_c,
					--write controls
					wen => wen,
					cen => cen,
					zen => zen
				);
end architecture;
