library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all_components.all;

entity control_decoder is
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
end entity;


architecture controls of control_decoder is

begin
	process(op_code,nop_code,condition_code)
		variable is_jlr_var : std_logic;
		variable a2c_var : std_logic_vector(1 downto 0);
		variable a1c_var : std_logic;
		variable rdc_var : std_logic_vector(1 downto 0);
		variable is_lm_sm_var : std_logic;
		variable dmem_c_var : std_logic;
		--Exec controls
		variable is_beq_var : std_logic;
		variable alu_c_var : std_logic_vector(1 downto 0);
		variable flag_c_var : std_logic_vector(1 downto 0);
		variable cflag_c_var : std_logic;
		variable zflag_c_var : std_logic;
		variable imm_var : std_logic;
		variable pc1_var : std_logic;
		variable is_lhi_var : std_logic;
		--Mem controls
		variable is_lw_var : std_logic;
		variable mem_w_c_var : std_logic;
		variable mem_r_c_var : std_logic;
		variable out_c_var : std_logic;
		variable z_c_var : std_logic;
		--write controls
		variable wen_var : std_logic;
		variable cen_var : std_logic;
		variable zen_var : std_logic;
		begin
			is_jlr_var := '0';
			a2c_var := "00";
			a1c_var := '0';
			rdc_var := "00";
			is_lm_sm_var := '0';
			dmem_c_var := '0';
			--Exec controls
			is_beq_var := '0';
			alu_c_var := "00";
			flag_c_var := "00";
			cflag_c_var := '0';
			zflag_c_var := '0';
			imm_var := '0';
			pc1_var := '0';
			is_lhi_var := '0';
			--Mem controls
			is_lw_var := '0';
			mem_w_c_var := '0';
			mem_r_c_var := '0';
			out_c_var := '0';
			z_c_var := '0';
			--write controls
			wen_var := '0';		--by default wen is 0
			cen_var := '0';
			zen_var := '0';
			
			if (nop_code = '1') then
			---need to do some default action
			---can be do no action
			else
			
				if (op_code = "0000" or op_code = "0010")then --add or nand
					a1c_var := '0'; --ra -> a1
					a2c_var := "01"; --rb -> a2
					rdc_var := "00"; --rc -> rd
					zflag_c_var := '1'; --set zero flag
					zen_var := '1';	--set zero flag in wb stage
					wen_var := '1'; --set wen to 1
					if (op_code = "0000") then
						alu_c_var := "00"; --add
						cflag_c_var := '1'; --set c flag
						cen_var := '1';--set c flag in wb stage
					elsif (op_code = "0010") then
						alu_c_var := "01"; --nand
					end if;
					if (condition_code = "10") then
						flag_c_var := "10";	--flag_forward = Cmem
					elsif (condition_code = "01") then
						flag_c_var := "01"; --flag forward = Zmem
					end if;


				elsif (op_code = "0001") then -- adi
					a1c_var := '0'; --ra -> a1
					rdc_var := "10"; --rb -> rdc
					flag_c_var := "00"; --flag forwarding
					cflag_c_var := '1';
					zflag_c_var := '1';
					alu_c_var := "00"; --addition
					imm_var := '1';	--imm data being used
					cen_var := '1';
					zen_var := '1';
					wen_var := '1';
					
				elsif (op_code = "0011")then	--lhi
					is_lhi_var := '1'; --lhi =1 for the exec stage
					rdc_var := "01"; -- ra->rdc
					wen_var := '1';
					
				elsif (op_code = "0100")then --lw
					a1c_var := '1'; --rb -> a1
					is_lw_var := '1';	--lw
					rdc_var := "01"; --ra -> rdc
					alu_c_var := "00"; --addition
					imm_var := '1'; 	--6b imm
					mem_r_c_var := '1'; --read from mem
					out_c_var := '1'; --chose output from mem
					z_c_var := '1'; --update zero flag in mem stage
					zen_var := '1';	--change z at end of instruction
					wen_var := '1';
					
				elsif (op_code = "0101") then --sw
					a1c_var := '1'; --rb -> a1
					a2c_var := 	"00"; --ra -> a2
					dmem_c_var := '1'; --a2 -> RM, d2 -> dmem
					alu_c_var := "00"; --addition
					imm_var := '1'; --6b imm
					mem_w_c_var := '1'; --write to memory
					
				elsif (op_code = "1100") then --beq
					a1c_var := '0'; --ra -> a1
					a2c_var := "01"; --rb -> a2
					is_beq_var := '1'; --beq
					alu_c_var := "10"; --do xor operation on the inputs
					
				elsif (op_code = "1000") then --jal
					rdc_var := "01"; --ra -> rdc
					alu_c_var := "00"; --addition
					pc1_var := '1'; --use +1 for alui1, and pc for alui2
					wen_var := '1';
					
				elsif (op_code = "1001") then --jlr
					rdc_var := "01"; --ra -> rdc
					a1c_var := '1'; --rb -> a1
					is_jlr_var := '1'; --jlr
					alu_c_var := "00"; --addition
					pc1_var := '1'; --pc + 1
					wen_var := '1';
				elsif (op_code = "0110") then --lm
					is_lm_sm_var := '1'; --lm
					rdc_var := "11"; --pe -> rdc
					a1c_var := '0'; --ra -> a1
					alu_c_var := "00"; --addition
					mem_r_c_var := '1'; --read from mem
					out_c_var := '1'; --output from mem
					wen_var := '1';
				elsif (op_code = "0111") then --sm
					is_lm_sm_var := '1'; --sm
					a2c_var := "10"; --pe -> a2
					a1c_var := '0'; --ra -> a1
					alu_c_var := "00"; --addition
					mem_w_c_var := '1'; --write to memory
				end if;
			end if;
			--RR controls
			is_jlr <= is_jlr_var;
			a2c <= a2c_var;
			a1c <= a1c_var;
			rdc <= rdc_var;
			is_lm_sm <= is_lm_sm_var;
			dmem_c <= dmem_c_var;
			--Exec controls
			is_beq <= is_beq_var;
			alu_c <= alu_c_var;
			flag_c <= flag_c_var; -- "00" for nothing, "10" C forwarding "01" Z forwarding "11" for both
			cflag_c <= cflag_c_var;
			zflag_c <= zflag_c_var;
			imm <= imm_var;
			pc1 <= pc1_var;
			is_lhi <= is_lhi_var;
			--Mem controls
			is_lw <= is_lw_var;
			mem_w_c <= mem_w_c_var;
			mem_r_c <= mem_r_c_var;
			out_c <= out_c_var;
			z_c <= z_c_var;
			--write controls
			wen <= wen_var;
			cen <= cen_var;
			zen <= zen_var;
		end process;
end architecture;










