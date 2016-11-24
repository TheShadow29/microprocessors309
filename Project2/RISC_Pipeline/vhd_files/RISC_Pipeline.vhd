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
		--signal ir_out : std_logic_vector(15 downto 0);
		--signal op_code : std_logic_vector(3 downto 0);
		--signal condition_code : std_logic_vector(1 downto 0);
		--signal ra : std_logic_vector(2 downto 0);
		--signal rb : std_logic_vector(2 downto 0);
		--signal rc : std_logic_vector(2 downto 0);
		--signal nine_bit_high : std_logic_vector(15 downto 0);
		--signal sign_ext_imm : std_logic_vector(15 downto 0);
		--signal eight_bit_lm_sm : std_logic_vector(7 downto 0);
		--signal is_lhi_dc, is_jal, is_lm_sm_dc: std_logic;
		--signal is_jlr, is_beq, is_lm_sm_rr, is_lhi_alu, is_lw, is_lm_sm_cd: std_logic;
		--signal nop_code,mem_w_c, mem_r_c, out_c, wen: std_logic;
		--signal a2c,rdc,alu_c, flag_c : std_logic_vector(1 downto 0);
		--signal a1c, dmem_c, cflag_c, zflag_c, zen, cen, imm, pc1, z_c: std_logic;
		
		---- FETCH STAGE SIGNALS ----
		signal pc_fetch_in, pc_fetch_out,
		       pc_fetch_p1, rom_data : std_logic_vector(15 downto 0);
		signal pc_fetch_enable, FD_pipeline_en: std_logic;
      constant signal const_ir_nop = (others => '1');
		
		-- 0 -> NOP
		-- 16 downto 1 -> IR
		-- 32 downto 17 -> PC
		signal FD_pipeline_in, FD_pipeline_out: std_logic_vector(32 downto 0);
		
		---- DECODE STAGE SIGNALS ----
		signal opcode_irdecoder: std_logic_vector(3 downto 0);
		signal ccode_irdecoder: std_logic_vector(1 downto 0);
		signal ra_irdecoder, rb_irdecoder, rc_irdecoder: std_logic_vector(2 downto 0);
		signal ninebithigh_irdecoder, imm_irdecoder: std_logic_vector(15 downto 0);
		signal lmsm_imm_irdecoder: std_logic_vector(7 downto 0);
		signal lhi_irdecoder, lmsm_irdecoder, jal_irdecoder, DRR_pipeline_en: std_logic;
		
		-- 0 -> NOP
		-- 3 downto 1 -> WB control
		-- 8 downto 4 -> Mem control
		-- 18 downto 9 -> Exec control
		-- 26 downto 19 -> RR control
		-- 35 downto 27 -> RA,RB,RC
		-- 51 downto 36 -> Tx
		-- 67 downto 52 -> Imm
		-- 83 downto 68 -> PC
		signal DRR_pipeline_in, DRR_pipeline_out: std_logic_vector(83 downto 0);
		
		---- REGREAD STAGE SIGNALS ----
		signal a1_regread, a2_regread, PE_regread: std_logic_vector(2 downto 0);
		signal regfile_d1, regfile_d2, PE_zp_regread: std_logic_vector(15 downto 0);
		
		signal jlr_regread, a1c_regread,
		       lmsm_regread, dmemc_regread,
				 V_regread                   : std_logic;
		signal a2c_regread, rdc_regread: std_logic_vector(1 downto 0);
		signal Txn_regread: std_logic_vector(7 downto 0);
		
		-- 0 -> NOP
		-- 3 downto 1 -> WB control
		-- 8 downto 4 -> Mem control
		-- 18 downto 9 -> Exec control
		-- 21 downto 19 -> Rmem
		-- 37 downto 22 -> Dmem
		-- 40 downto 38 -> RD
		-- 43 downto 41 -> RS1
		-- 59 downt0 44 -> ALU1
		-- 62 downto 60 -> RS2
		-- 78 downto 63 -> ALU2
		-- 94 downto 79 -> Imm 
	   -- 110 downto 95 -> PC
		signal RRE_pipeline_in, RRE_pipeline_out: std_logic_vector(110 downto 0);
		
		---- EXEC STAGE SIGNALS ----
		signal lhi_exec, pc1_exec, immc_exec,
		       beq_exec, zflagc_exec, cflagc_exec,
				 stall_beq, stall_lw,
				 alu1_exec_stall, alu2_exec_stall, dmem_exec_stall,
				 alu_c, alu_z, stall_flagfwd, nop_exec: std_logic;
		signal aluc_exec, flagc_exec: std_logic_vector(1 downto 0);
		
		signal alu1_exec, alu2_exec, dmem_exec,
		       alu_in1, alu_in2, alu_out: std_logic_vector(15 downto 0);
				 
		-- 0 -> NOP
		-- 8 downto 1 -> M/WB controls
		-- 24 downto 9 -> Dmem
		-- 27 downto 25 -> RD
		-- 43 downto 28 -> ADmem 
		-- 44 -> Cmem 
		-- 45 -> Zmem 
      -- 61 downto 46 -> PC		
		signal EM_pipeline_in, EM_pipeline_out: std_logic_vector(61 downto 0);
		
		---- MEMORY STAGE SIGNALS ----
		signal mw_memory, mr_memory, lw_memory,
		       outc_memory, zc_memory,
				 c_memory, z_memory, ram_z       : std_logic;
		signal ram_dout: std_logic_vector(15 downto 0);		 
		
		-- 0 -> NOP
		-- 3 downto 1 -> WB controls
		-- 6 downto 4 -> RD
		-- 22 downto 7 -> Dwb
		-- 23 -> Cwb
		-- 24 -> Zwb 
		-- 40 downto 25 -> PC
		signal MWB_pipeline_in, MWB_pipeline_out: std_logic_vector(40 downto 0);
		
		---- WRITEBACK STAGE SIGNALS ----
		signal cen_writeback, zen_writeback, wen_writeback,
		       pcupd_stall, pcupd_wen_out, pcupd_r7upd: std_logic;
				
		signal pc_writeback: std_logic_vector(15 downto 0);
begin
	
------------------ FETCH STAGE ----------------------

pc_fetch: DataRegister port map (Din=>pc_fetch_in, Dout=>pc_fetch_out, clk=>clk, enable=>pc_fetch_enable);
pc_incr_fetch: Incrementer port map (x=>pc_fetch_out, z=>pc_fetch_p1);
program_rom1: program_rom port map
	(
		address => pc_fetch_out(13 downto 0),
		q => rom_data,
		clock => clk
	);

pc_fetch_in <= history_pcout when history_bren = '1' else 
               data_writeback if pcupd_wen_out = '1' else 
					pc_exec_p1 if stall_beq = '1' else
					regfile_d1 if jlr_regread = '1' else
					pc_decode_p1 if jal_irdecoder = '1' else
					pc_fetch_p1;
					
pc_fetch_enable <= not(stall_lw or lmsm_regread);
FD_pipeline_en <= not(V_regread);

-- IR register --
FD_pipeline_in(16 downto 1) <= const_ir_nop when
											history_stall = '1' or
											pcupd_stall = '1' or
											jlr_regread = '1' or
											stall_beq = '1' or
											jal_irdecoder = '1' 
										 else rom_data;
-- FD nop --									 
FD_pipeline_in(0) <= '1' when 
								history_stall = '1' or
								pcupd_stall = '1' or
								jlr_regread = '1' or
								stall_beq = '1' or
								jal_irdecoder = '1'
							 else '0';
							 
-- FD PC register --
FD_pipeline_in(32 downto 17) <= pc_fetch_out;

FD_pipeline: DataRegister port map 
	(
		Din => FD_pipeline_in,
		Dout => FD_pipeline_out,
		clk => clk,
		enable => FD_pipeline_en
	);

------------------ DECODE STAGE ----------------------

id : instruction_decoder port map 
	(
		-- ir_out => ir_out, <- Why needed?
		op_code => opcode_irdecoder,
		condition_code => ccode_irdecoder,
		ra => ra_irdecoder,
		rb => rb_irdecoder,
		rc => rc_irdecoder,
		nine_bit_high => ninebithigh_irdecoder, 
		sign_ext_imm => imm_irdecoder,
		eight_bit_lm_sm => lmsm_imm_irdecoder,
		is_lhi => lhi_irdecoder,
		is_jal => jal_irdecoder,
		is_lm_sm => lmsm_irdecoder
	);
	
cd : control_decoder port map
	(
		op_code => opcode_irdecoder,
		condition_code => ccode_irdecoder,
		nop_code => FD_pipeline_out(0),
		--RR controls
		is_jlr => DRR_pipeline_in(19),
		a2c => DRR_pipeline_in(21 downto 20),
		a1c => DRR_pipeline_in(22),
		rdc => DRR_pipeline_in(24 downto 23),
		is_lm_sm => DRR_pipeline_in(25),
		dmem_c => DRR_pipeline_in(26),
		--Exec controls
		is_beq => DRR_pipeline_in(9),
		alu_c => DRR_pipeline_in(11 downto 10),
		flag_c => DRR_pipeline_in(13 downto 12), -- "00" for nothing, "10" C forwarding "01" Z forwarding "11" for both
		cflag_c => DRR_pipeline_in(14),
		zflag_c => DRR_pipeline_in(15),
		imm => DRR_pipeline_in(16),
		pc1 => DRR_pipeline_in(17),
		is_lhi => DRR_pipeline_in(18),
		--Mem controls
		is_lw => DRR_pipeline_in(4),
		mem_w_c => DRR_pipeline_in(5),
		mem_r_c => DRR_pipeline_in(6),
		out_c => DRR_pipeline_in(7),
		z_c => DRR_pipeline_in(8),
		--write controls
		wen => DRR_pipeline_in(1),
		cen => DRR_pipeline_in(2),
		zen => DRR_pipeline_in(3)
	);
	
DRR_pipeline_in(29 downto 27) <= ra_irdecoder;
DRR_pipeline_in(32 downto 30) <= rb_irdecoder;
DRR_pipeline_in(35 downto 33) <= rc_irdecoder;
	
DRR_pipeline_in(51 downto 36) <= Txn_regread when lmsm_regread = '1' else
											lmsm_imm_irdecoder when lmsm_irdecoder = '1' else
											(others => '0');


DRR_pipeline_in(67 downto 52) <= ninebithigh_irdecoder when lhi_irdecoder = '1' else
											imm_irdecoder;
-- PC --
DRR_pipeline_in(83 downto 68) <= FD_pipeline_out(32 downto 17);

-- NOP --
DRR_pipeline_in(0) <= pcupd_stall or
                      jlr_regread or
							 history_stall or
							 stall_beq or
							 FD_pipeline_out(0);
							 
DRR_pipeline: DataRegister port map
	(
		Din => DRR_pipeline_in,
		Dout => DRR_pipeline_out,
		enable => DRR_pipeline_en,
		clk => clk
	);
	
DRR_pipeline_en <= not(V_regread);

------------------ REGREAD STAGE ----------------------

RR_control: ControlWord port map
	(	
		nop => DRR_pipeline_out(0),
		cin => DRR_pipeline_out(26 downto 19),
		cout(0) => jlr_regread,
		cout(2 downto 1) => a2c_regread,
		cout(3) => a1c_regread,
		cout(5 downto 4) => rdc_regread,
		cout(6) => lmsm_regread,
		cout(7) => dmemc_regread
	);
	
register_file: regfile port map
	(
		A1 => a1_regread,
		D1 => regfile_d1,
		A2 => a2_regread,
		D2 => regfile_d2,
		A3 => rd_writeback,
		D3 => data_writeback,
		
		WR => wen_writeback,
		R7upd => pcupd_r7upd,
		PC => pc_writeback,
		
		clk => clk;
	);
	
lmsm_pe: priority_encoder port map
	(
		x => DRR_pipeline_out(51 downto 36),
		S => PE_regread,
		Tn => Tnx_regread,
		N => V_regread
	);
	
PE_zp_regread(2 downto 0) <= PE_regread;
PE_zp_regread(15 downto 3) <= (others => '0');

a1_regread <= DRR_pipeline_out(32 downto 30) when a1c_regread = '1' else
				  DRR_pipeline_out(29 downto 27);
				  
a2_regread <= PE_regread when a2c_regread = "10" else 
				  DRR_pipeline_out(32 downto 30) when a2c_regread = "01" else
				  DRR_pipeline_out(29 downto 27);
				  
RRE_pipeline : DataRegister port map 
	(
		Din => RRE_pipeline_in,
		Dout => RRE_pipeline_out,
		enable => '1',
		clk => clk
	);

-- NOP --
RRE_pipeline_in(0) <= DRR_pipeline_out(0) or
							 pcupd_stall or
							 history_stall or
							 stall_beq;
							 
-- 3 downto 1 -> WB control
-- 8 downto 4 -> Mem control
-- 18 downto 9 -> Exec control
RRE_pipeline_in(18 downto 1)	<= DRR_pipeline_out(18 downto 1);			 

-- Rmem --
RRE_pipeline_in(21 downto 19) <= a1_regread when dmemc_regread = '0' else
											a2_regread;
-- Dmem --
RRE_pipeline_in(37 downto 22) <= regfile_d1 when dmemc_regread = '0' else
											regfile_d2;
-- RD | 35 downto 27 -> RA,RB,RC -- 
RRE_pipeline_in(40 downto 38) <= DRR_pipeline_out(35 downto 33) when RDc_regread = "00" else
											DRR_pipeline_out(32 downto 30) when RDc_regread = "10" else
											DRR_pipeline_out(29 downto 27) when RDc_regread = "01" else
											PE_regread;
-- RS1/2 | ALU1/2 --
RRE_pipeline_in(43 downto 41) <= a1_regread;
RRE_pipeline_in(59 downto 44) <= regfile_d1;
RRE_pipeline_in(62 downto 60) <= a2_regread;
RRE_pipeline_in(78 downto 63) <= regfile_d2 when lmsm_regread = '0' else
                                 PE_zp_regread;

-- Imm --
RRE_pipeline_in(94 downto 79) <= DRR_pipeline_out(67 downto 52);
-- PC --
RRE_pipeline_in(110 downto 95) <= DRR_pipeline_out(83 downto 68);


----------------------------- EXEC STAGE -----------------------------------

exec_control: ControlWord port map
	(
		nop => nop_exec,
		cin => RRE_pipeline_out(18 downto 9),
		cout(9) => lhi_exec,
		cout(8) => pc1_exec,
		cout(7) => immc_exec,
		cout(6) => zflagc_exec,
		cout(5) => cflagc_exec,
		cout(4 downto 3) => flagc_exec,
		cout(2 downto 1) => aluc_exec,
		cout(0) => beq_exec
	);

stall_beq <= beq_exec and alu_z;

alu1_forward : ForwardingUnit port map
	(
		Rsrc => RRE_pipeline_out(43 downto 41),
		Rmem => rd_mem,
		Rwb => rd_wb,
		
		NOPmem => EM_pipeline_out(0),
		NOPwb => MWB_pipeline_out(0),
		LW => lw_memory,
		
		Idef => RRE_pipeline_out(59 downto 44),
		Imem => ad_memory,
		Iwb => d_writeback,
		Ipc => RRE_pipeline_out(110 downto 95)
		
		Fout => alu1_exec,
		Stall => alu1_exec_stall
	);

alu2_forward : ForwardingUnit port map
	(
		Rsrc => RRE_pipeline_out(62 downto 60),
		Rmem => rd_mem,
		Rwb => rd_wb,
		
		NOPmem => EM_pipeline_out(0),
		NOPwb => MWB_pipeline_out(0),
		LW => lw_memory,
		
		Idef => RRE_pipeline_out(78 downto 63),
		Imem => ad_memory,
		Iwb => d_writeback,
		Ipc => RRE_pipeline_out(110 downto 95)
		
		Fout => alu1_exec,
		Stall => alu1_exec_stall
	);
	
dmem_forward : ForwardingUnit port map
	(
		Rsrc => RRE_pipeline_out(21 downto 19),
		Rmem => rd_mem,
		Rwb => rd_wb,
		
		NOPmem => EM_pipeline_out(0),
		NOPwb => MWB_pipeline_out(0),
		LW => lw_memory,
		
		Idef => RRE_pipeline_out(37 downto 22),
		Imem => ad_memory,
		Iwb => d_writeback,
		Ipc => RRE_pipeline_out(110 downto 95)
		
		Fout => dmem_exec,
		Stall => dmem_exec_stall
	);

alu_exec: alu port map
	(
		X => alu_in1,
		Y => alu_in2,
		out_p => alu_out,
		
		op_code => aluc_exec(0),
		do_xor => aluc_exec(1),
		
		C => alu_c,
		Z => alu_z
	);

alu_in1 <= alu1_exec when pc1_exec = '0' else
           "0000000000000001";
alu_in2 <= RRE_pipeline_out(94 downto 79) when immc_exec = '1' else
           RRE_pipeline_out(110 downto 0) when pc1_exec = '1' else
			  alu2_exec;
			  
flagfwd_exec: FlagForwardingUnit port map
	(
		Flag => flagc_exec,
		Cmem => c_memory,
		Zmem => z_memory,
		
		ForwardOut => stall_flagfwd
	);
nop_exec <= RRE_pipeline_out(0) or stall_flagfwd;
			  
EM_pipeline : DataRegister port map 
	(
		Din => EM_pipeline_in,
		Dout => EM_pipeline_out,
		enable => '1',
		clk => clk
	);
	
-- NOP --
EM_pipeline_in(0) <= nop_exec or
							pcupd_stall;
-- WB|M control --
EM_pipeline_in(8 downto 1) <= RRE_pipeline_out(8 downto 1);

-- Dmem --
EM_pipeline_in(24 downto 9) <= dmem_exec;
-- RD --
EM_pipeline_in(27 downto 25) <= RRE_pipeline_out(40 downto 38);
-- ADmem --
EM_pipeline_in(43 downto 28) <= RRE_pipeline_out(94 downto 79) when LHI_exec = '1' else
										  alu_out;
										
-- C/Z --
EM_pipeline_in(44) <= alu_c when cflagc_exec = '1' else
                      c_memory;
EM_pipeline_in(45) <= alu_z when zflagc_exec = '1' else
                      z_memory;							 
-- PC --
EM_pipeline_in(61 downto 46) <= RRE_pipeline_out(110 downto 95);

------------------ MEMORY STAGE ------------------
memory_control: ControlWord port map
	(
		cin => EM_pipeline_out(8 downto 4),
		cout(4) => zc_memory,
		cout(3) => outc_memory,
		cout(2) => mr_memory,
		cout(1) => mw_memory,
		cout(0) => lw_memory,
	);

data_ram1: data_ram port map
	(
		address => EM_pipeline_out(43 downto 28),
		data => EM_pipeline_out(24 downto 9),
		wren => mw_memory,
		q => ram_dout,
		clock => clk
	);

ram_z <= '1' when ram_dout = "0000000000000000" else '0';

MWB_pipeline: DataRegister port map
	(
		Din => MWB_pipeline_in,
		Dout => MWB_pipeline_out,
		enable => '1',
		clk => clk
	);
	
c_memory <= EM_pipeline_out(44);
z_memory <= ram_z when zc_memory = '1' else
            EM_pipeline_out(45);
	
-- NOP --
MWB_pipeline_in(0) <= EM_pipeline_out(0) or pcupd_stall;
-- WB control --
MWB_pipeline_in(3 downto 1) <= EM_pipeline_out(3 downto 1);
-- RD --
MWB_pipeline_in(6 downto 4) <= EM_pipeline_out(27 downto 25);
-- Dwb --
MWB_pipeline_in(22 downto 7) <= ram_dout when outc_memory = '1' else
                                EM_pipeline_out(43 downto 28);
-- Cwb/Zwb --
MWB_pipeline_in(23) <= c_memory;
MWB_pipeline_in(24) <= z_memory;
-- PC --
MWB_pipeline_in(40 downto 25) <= EM_pipeline_in(61 downto 46);


------------------ WRITEBACK STAGE ------------------

wb_control: ControlWord port map
	(
		nop => MWB_pipeline_out(0),
		cin => MWB_pipeline_out(3 downto 1),
		cout(0) => wen_writeback,
		cout(1) => cen_writeback,
		cout(2) => zen_writeback
	);
	
pcupd_block: PCUpdate port map
   (
		RD => MWB_pipeline_out(6 downto 4),
		WENin => wen_writeback,
		
		WENout => pcupd_wen_out,
		R7upd => pcupd_r7upd,
		Stall => pcupd_stall
	);
	
creg: DataRegister port map (
			Din => MWB_pipeline_out(23 downto 23),
			-- Dout => ??
			enable => cen_writeback,
			clk => clk
		);

zreg: DataRegister port map (
			Din => MWB_pipeline_out(24 downto 24),
			-- Dout => ??
			enable => zen_writeback,
			clk => clk
		);
		
pc_writeback <= MWB_pipeline_out(40 downto 25);

end architecture;
