library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all_components.all;

entity data_path is
	port
	(
		clk, reset, start : in std_logic;
		done : out std_logic := '0'
	);
end entity;

architecture data of data_path is
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
		       pc_fetch_p1, history_pcout, history_pcout_beq, history_pcout_jal : std_logic_vector(15 downto 0) := (others=>'0');
		signal rom_data : std_logic_vector(15 downto 0) := (others => '1');
		signal pc_fetch_enable, FD_pipeline_en, history_bren, history_bren_beq, history_bren_jal,
		       history_stall_beq, history_stall_jal: std_logic := '0';
      constant const_ir_nop: std_logic_vector(15 downto 0) := (others => '1');
		
		-- 0 -> NOP
		-- 16 downto 1 -> IR
		-- 32 downto 17 -> PC
		signal FD_pipeline_in, FD_pipeline_out: std_logic_vector(32 downto 0) := (0 => '1', others=>'0');
		
		---- DECODE STAGE SIGNALS --w--
		signal opcode_irdecoder: std_logic_vector(3 downto 0) := (others=>'0');
		signal ccode_irdecoder: std_logic_vector(1 downto 0) := (others=>'0');
		signal ra_irdecoder, rb_irdecoder, rc_irdecoder: std_logic_vector(2 downto 0) := (others=>'0');
		signal ninebithigh_irdecoder, imm_irdecoder, pc_decode, pc_decode_p1: std_logic_vector(15 downto 0) := (others=>'0');
		signal lmsm_imm_irdecoder: std_logic_vector(7 downto 0) := (others=>'0');
		signal lhi_irdecoder, lmsm_irdecoder, jal_irdecoder,
				 DRR_pipeline_en, DRR_pipeline_pe_en: std_logic := '0';
		
		-- 0 -> NOP
		-- 3 downto 1 -> WB control
		-- 8 downto 4 -> Mem control
		-- 18 downto 9 -> Exec control
		-- 26 downto 19 -> RR control
		-- 35 downto 27 -> RA,RB,RC
		-- 43 downto 36 -> Tx
		-- 59 downto 44 -> Imm
		-- 75 downto 60 -> PC
		signal DRR_pipeline_in, DRR_pipeline_out: std_logic_vector(75 downto 0) := (0 => '1', others=>'0');
		
		---- REGREAD STAGE SIGNALS ----
		signal a1_regread, a2_regread, PE_regread: std_logic_vector(2 downto 0) := (others=>'0');
		signal regfile_d1, regfile_d2, PE_zp_regread, d1_regread_jlr: std_logic_vector(15 downto 0) := (others=>'0');
		
		signal jlr_regread, a1c_regread,
		       lmsm_regread, dmemc_regread,
				 V_regread, freeze_jlr, RRE_pipeline_en: std_logic := '0';
		signal a2c_regread, rdc_regread: std_logic_vector(1 downto 0) := (others=>'0');
		signal Txn_regread: std_logic_vector(7 downto 0) := (others=>'0');
		
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
		signal RRE_pipeline_in, RRE_pipeline_out: std_logic_vector(110 downto 0) := (0 => '1', others=>'0');
		 
		---- EXEC STAGE SIGNALS ----
		signal lhi_exec, pc1_exec, immc_exec,
		       beq_exec, zflagc_exec, cflagc_exec,
				 stall_beq, stall_lw,
				 alu1_exec_stall, alu2_exec_stall, dmem_exec_stall,
				 alu_c, alu_z, nop_flagfwd,
				 flagfwd_stall, nop_exec, wen_exec, LW_exec: std_logic := '0';
		signal aluc_exec, flagc_exec: std_logic_vector(1 downto 0) := (others => '0');
		signal rd_exec: std_logic_vector(2 downto 0) := (others => '0');
		signal exec_control_in : std_logic_vector(11 downto 0) := (others => '0');
		
		signal alu1_exec, alu2_exec, dmem_exec,
		       alu_in1, alu_in2, alu_out,
				 pc_exec, pc_exec_p1, pc_exec_next, pc_exec_pimm: std_logic_vector(15 downto 0) := (others=>'0');
				 
		-- 0 -> NOP
		-- 8 downto 1 -> M/WB controls
		-- 24 downto 9 -> Dmem
		-- 27 downto 25 -> RD
		-- 43 downto 28 -> ADmem 
		-- 44 -> Cmem 
		-- 45 -> Zmem 
      -- 61 downto 46 -> PC		
		signal EM_pipeline_in, EM_pipeline_out: std_logic_vector(61 downto 0) := (0 => '1', others=>'0');
		
		---- MEMORY STAGE SIGNALS ----
		signal mw_memory, mr_memory, lw_memory,
		       outc_memory, zc_memory,
				 c_memory, z_memory, ram_z, wen_memory : std_logic := '0';
		signal ram_dout, ad_memory: std_logic_vector(15 downto 0) := (others=>'0');
		signal rd_memory: std_logic_vector(2 downto 0) := (others=>'0');
		signal memory_control_in : std_logic_vector(5 downto 0) := (others => '0');
		
		-- 0 -> NOP
		-- 3 downto 1 -> WB controls
		-- 6 downto 4 -> RD
		-- 22 downto 7 -> Dwb
		-- 23 -> Cwb
		-- 24 -> Zwb 
		-- 40 downto 25 -> PC
		signal MWB_pipeline_in, MWB_pipeline_out: std_logic_vector(40 downto 0) := (0 => '1', others=>'0');
		
		---- WRITEBACK STAGE SIGNALS ----
		signal cen_writeback, zen_writeback, wen_writeback,
		       pc_r7_upd_stall, pc_r7_upd_wen_out, pcupd_r7upd: std_logic := '0';
		signal ctmp_writeback, ztmp_writeback: std_logic_vector(0 downto 0) := (others=>'0'); ---------NOT SURE if reqd not used ?-----------
				 
		signal rd_writeback: std_logic_vector(2 downto 0) := (others=>'0');				
		signal pc_writeback, d_writeback: std_logic_vector(15 downto 0) := (others=>'0');
		
		constant zero_8bit : std_logic_vector(7 downto 0) := (others => '0');
		constant one_16bit : std_logic_vector(15 downto 0) := (0 => '1', others => '0');
		constant zero_16bit : std_logic_vector(15 downto 0) := (others => '0');
begin
	
------------------ FETCH STAGE ----------------------

pc_fetch: DataRegister port map (Din=>pc_fetch_in, Dout=>pc_fetch_out, clk=>clk,reset=>reset,enable=>pc_fetch_enable);
pc_incr_fetch: Incrementer port map (x=>pc_fetch_out, z=>pc_fetch_p1);
program_rom1: program_rom port map
	(
		address => pc_fetch_out(9 downto 0),
		q => rom_data,
		clock => clk
	);
--	
--beq_history:  port map
--	(
--		pc_br => pc_exec,
--		pc_br_next => pc_exec_pimm,
--		hin => stall_beq,
--		clk => clk,
--		BEQ => beq_exec,
--		pc_in => pc_fetch_out,
--		br_en => history_bren,
--		pc_out => history_pcout,
--		stall_hist => history_stall
--	);

history_parallel_beq: history_block_parallel generic map (size => 8) 
	port map
	(
		pc_br => pc_exec,
		pc_br_next => pc_exec_pimm,
		br_d => stall_beq,
		clk => clk,
		reset => reset,
		BEQ => beq_exec,
		pc_in => pc_fetch_out,
		br_en => history_bren_beq,
		pc_out => history_pcout_beq,
		stall_hist => history_stall_beq
	);
	
history_parallel_jal: history_block_parallel generic map (size => 8) 
	port map
	(
		pc_br => pc_decode,
		pc_br_next => pc_decode_p1,
		br_d => '1',
		clk => clk,
		reset => reset,
		BEQ => jal_irdecoder,
		pc_in => pc_fetch_out,
		br_en => history_bren_jal,
		pc_out => history_pcout_jal,
		stall_hist => history_stall_jal
	);

history_pcout <= history_pcout_beq when history_bren_beq = '1' else 
					  history_pcout_jal when history_bren_jal = '1' else
					  (others => '0');
history_bren <= history_bren_beq or history_bren_jal;
--history_parallel: history_block_parallel generic map (size => 8) 
--	port map
--	(
--		pc_br => pc_exec,
--		pc_br_next => pc_exec_pimm,
--		br_d => stall_beq,
--		clk => clk,
--		reset => reset,
--		BEQ => beq_exec,
--		pc_in => pc_fetch_out,
--		br_en => history_bren,
--		pc_out => history_pcout,
--		stall_hist => history_stall
--	);

-- history_fraud : history_block_fraud
--		port map 
--		(
--			stall_beq => stall_beq,
--			BEQ => beq_exec,
--			pc_br_next => pc_exec_pimm,
--			pc_out => history_pcout,
--			br_en => history_bren,
--			stall_hist => history_stall
--		);
--history_bren <= '0';
--history_pcout <= (others => '0');
--history_stall <= '0';
pc_fetch_in <= history_pcout when history_bren = '1' else 
               d_writeback when pc_r7_upd_wen_out = '1' else 
					pc_exec_next when history_stall_beq = '1' else
					d1_regread_jlr when jlr_regread = '1' else
					pc_decode_p1 when history_stall_jal = '1' else
					pc_fetch_p1;
					
pc_fetch_enable <= not(stall_lw or (V_regread and lmsm_regread) or freeze_jlr);

FD_pipeline_en <= not((V_regread and lmsm_regread) or stall_lw or freeze_jlr);

-- IR register --
FD_pipeline_in(16 downto 1) <= const_ir_nop when
											pc_r7_upd_stall = '1' or
											jlr_regread = '1' or
											history_stall_beq = '1' or
											history_stall_jal = '1' 
										 else rom_data;
-- FD nop --									 
FD_pipeline_in(0) <= '1' when 
								pc_r7_upd_stall = '1' or
								jlr_regread = '1' or
								history_stall_beq = '1' or
								history_stall_jal = '1'
							 else '0';
							 
-- FD PC register --
FD_pipeline_in(32 downto 17) <= pc_fetch_out;

FD_pipeline: PipelineDataRegister port map 
	(
		Din => FD_pipeline_in,
		Dout => FD_pipeline_out,
		clk => clk,
		reset=>reset,
		enable => FD_pipeline_en
	);

------------------ DECODE STAGE ----------------------

id : instruction_decoder port map 
	(
		ir_out => FD_pipeline_out(16 downto 1),
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
	
pc_decode <= FD_pipeline_out(32 downto 17);
pc_adder_decode: Adder port map
	(
		X => pc_decode,
		Y => imm_irdecoder,
		-- cout => NULL,
		Z => pc_decode_p1
	);
	
DRR_pipeline_in(29 downto 27) <= ra_irdecoder;
DRR_pipeline_in(32 downto 30) <= rb_irdecoder;
DRR_pipeline_in(35 downto 33) <= rc_irdecoder;
	
DRR_pipeline_in(43 downto 36) <= Txn_regread when (lmsm_regread = '1' and V_regread = '1') else
											lmsm_imm_irdecoder when (lmsm_irdecoder = '1' and V_regread = '0') else
											(others => '0');
-- Imm --
DRR_pipeline_in(59 downto 44) <= ninebithigh_irdecoder when lhi_irdecoder = '1' else
											imm_irdecoder;
-- PC --
DRR_pipeline_in(75 downto 60) <= pc_decode;

-- NOP --
DRR_pipeline_in(0) <= pc_r7_upd_stall or
                      jlr_regread or
							 history_stall_beq or
							 FD_pipeline_out(0);
							 
DRR_pipeline: PipelineDataRegister port map
	(
		Din => DRR_pipeline_in(35 downto 0),
		Dout => DRR_pipeline_out(35 downto 0),
		enable => DRR_pipeline_en,
		clk => clk,
		reset=>reset
	);

DRR_pipeline_pe: DataRegister port map
	(
		Din => DRR_pipeline_in(43 downto 36),
		Dout => DRR_pipeline_out(43 downto 36),
		enable => DRR_pipeline_pe_en,
		clk => clk,
		reset=>reset
	);

DRR_pipeline2: DataRegister port map
	(
		Din => DRR_pipeline_in(75 downto 44),
		Dout => DRR_pipeline_out(75 downto 44),
		enable => DRR_pipeline_en,
		clk => clk,
		reset=>reset
	);
		
	
DRR_pipeline_en <= not((V_regread and lmsm_regread) or stall_lw or freeze_jlr);
DRR_pipeline_pe_en <= not(stall_lw or freeze_jlr);

------------------ REGREAD STAGE ----------------------

RR_control: ControlWord generic map (size=>8) port map
	(	
		nop => DRR_pipeline_out(0),
		cin => DRR_pipeline_out(26 downto 19),
		cout(0) => jlr_regread,
		cout(1) => a2c_regread(0),
		cout(2) => a2c_regread(1),
		cout(3) => a1c_regread,
		cout(4) => rdc_regread(0),
		cout(5) => rdc_regread(1),
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
		D3 => d_writeback,
		
		WR => wen_writeback,
		R7upd => pcupd_r7upd,
		PC => pc_writeback,
		
		clk => clk,
		reset => reset
	);
	
lmsm_pe: PriorityEncoder port map
	(
		x => DRR_pipeline_out(43 downto 36),--Tx value
		S => PE_regread,
		Tn => Txn_regread,
		N => V_regread
	);
	
PE_zp_regread(2 downto 0) <= PE_regread;
PE_zp_regread(15 downto 3) <= (others => '0');

--32-30 : rb
--29-27 : ra
a1_regread <= DRR_pipeline_out(32 downto 30) when a1c_regread = '1' else
				  DRR_pipeline_out(29 downto 27);
				  
a2_regread <= PE_regread when a2c_regread = "10" else 
				  DRR_pipeline_out(32 downto 30) when a2c_regread = "01" else
				  DRR_pipeline_out(29 downto 27);
				  
jlr_forward: forwarding_unit_jlr port map
	(
		Rsrc => a1_regread,
		Rmem => rd_memory,
		Rwb => rd_writeback,
		Rexec => rd_exec,
		
		NOPexec => RRE_pipeline_out(0),
		NOPmem => EM_pipeline_out(0),
		NOPwb => MWB_pipeline_out(0),
		
		LWmem => lw_memory,
		LWexec => lw_exec,
		JLR => JLR_regread,
		Wen_exec => wen_exec,
		Wen_mem => wen_memory,
		Wen_wb => wen_writeback,
		
		Idef => regfile_d1,
		Ialu_out => alu_out,
		Imem_out => ram_dout,
		Ipc => DRR_pipeline_out(75 downto 60),
	
		Fout => d1_regread_jlr,
		Freeze => freeze_jlr
	);

RRE_pipeline_en <= not(stall_lw);

RRE_pipeline : PipelineDataRegister port map 
	(
		Din => RRE_pipeline_in,
		Dout => RRE_pipeline_out,
		enable => RRE_pipeline_en,					---------NOT SURE-----------if always '1'---------
		clk => clk,
		reset=>reset
	);

-- NOP --
RRE_pipeline_in(0) <= DRR_pipeline_out(0) or
							 pc_r7_upd_stall or
							 history_stall_beq or
							 freeze_jlr;
							 
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
RRE_pipeline_in(62 downto 60) <= a2_regread;------------need to take care in forwardingUnit
RRE_pipeline_in(78 downto 63) <= regfile_d2;

-- Imm --
RRE_pipeline_in(94 downto 79) <= DRR_pipeline_out(59 downto 44) when lmsm_regread = '0' else
                                 PE_zp_regread;
-- PC --
RRE_pipeline_in(110 downto 95) <= DRR_pipeline_out(75 downto 60);


----------------------------- EXEC STAGE -----------------------------------
exec_control_in(11) <= RRE_pipeline_out(4);
exec_control_in(10) <= RRE_pipeline_out(1);
exec_control_in(9 downto 0) <= RRE_pipeline_out(18 downto 9);

exec_control: ControlWord generic map (size=>12)  port map
	(
		nop => nop_exec,
		cin => exec_control_in,
		cout(11) => LW_exec,
		cout(10) => wen_exec,
		cout(9) => lhi_exec,
		cout(8) => pc1_exec,
		cout(7) => immc_exec,
		cout(6) => zflagc_exec,
		cout(5) => cflagc_exec,
		cout(3) => flagc_exec(0),
		cout(4) => flagc_exec(1),
		cout(1) => aluc_exec(0),
		cout(2) => aluc_exec(1),
		cout(0) => beq_exec
	);
--------------------------NOT SURE-------------------------
stall_beq <= beq_exec and alu_z;---should be dependence on history bit
--stall_beq <= '0';
alu1_forward : ForwardingUnit port map
	(
		Rsrc => RRE_pipeline_out(43 downto 41),
		Rmem => rd_memory,
		Rwb => rd_writeback,
		
		NOPmem => EM_pipeline_out(0),
		NOPwb => MWB_pipeline_out(0),
		LW => lw_memory,
		Wen_mem => wen_memory,
		Wen_wb => wen_writeback,
		
		
		Idef => RRE_pipeline_out(59 downto 44),
		Imem => ad_memory,
		Iwb => d_writeback,
		Ipc => RRE_pipeline_out(110 downto 95),
		
		Fout => alu1_exec,
		Stall => alu1_exec_stall
	);

alu2_forward : ForwardingUnit port map
	(
		Rsrc => RRE_pipeline_out(62 downto 60),
		Rmem => rd_memory,
		Rwb => rd_writeback,
		
		NOPmem => EM_pipeline_out(0),
		NOPwb => MWB_pipeline_out(0),
		LW => lw_memory,
		Wen_mem => wen_memory,
		Wen_wb => wen_writeback,
		
		Idef => RRE_pipeline_out(78 downto 63),
		Imem => ad_memory,
		Iwb => d_writeback,
		Ipc => RRE_pipeline_out(110 downto 95),	
		
		Fout => alu2_exec,
		Stall => alu2_exec_stall
	);
	
dmem_forward : ForwardingUnit port map
	(
		Rsrc => RRE_pipeline_out(21 downto 19),
		Rmem => rd_memory,
		Rwb => rd_writeback,
		
		NOPmem => EM_pipeline_out(0),
		NOPwb => MWB_pipeline_out(0),
		LW => lw_memory,
		Wen_mem => wen_memory,
		Wen_wb => wen_writeback,
			
		Idef => RRE_pipeline_out(37 downto 22),
		Imem => ad_memory,
		Iwb => d_writeback,
		Ipc => RRE_pipeline_out(110 downto 95),
		
		Fout => dmem_exec,
		Stall => dmem_exec_stall
	);
	
stall_lw <= dmem_exec_stall or alu1_exec_stall or alu2_exec_stall or flagfwd_stall;

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
           one_16bit;
--94 - 79: imm
--110 - 95 : pc
alu_in2 <= RRE_pipeline_out(94 downto 79) when immc_exec = '1' else
           RRE_pipeline_out(110 downto 95) when pc1_exec = '1' else
			  alu2_exec;
			  
flagfwd_exec: FlagForwardingUnit port map
	(
		NOPmem => EM_pipeline_out(0),
		Flag => RRE_pipeline_out(13 downto 12),
		Cmem => c_memory,
		Zmem => z_memory,
		LW => lw_memory,
		
		ForwardOut => nop_flagfwd,
		Stall => flagfwd_stall
	);
	
---------- COMBINATIONAL LOOP -------------
nop_exec <= RRE_pipeline_out(0) or nop_flagfwd or stall_lw;

pc_exec <= RRE_pipeline_out(110 downto 95);
--PC + Imm	
pc_imm_adder_exec: Adder port map
	(
		X => pc_exec,
		Y => RRE_pipeline_out(94 downto 79),
		-- cout => NULL,
		Z => pc_exec_pimm
	);
pc_incr_exec: Incrementer port map
	(
		X => pc_exec,
		Z => pc_exec_p1
	);
pc_exec_next <= pc_exec_pimm when stall_beq ='1' else pc_exec_p1;
EM_pipeline : PipelineDataRegister port map 
	(
		Din => EM_pipeline_in,
		Dout => EM_pipeline_out,
		enable => '1',---------NOT SURE-----------if always '1'---------
		clk => clk,
		reset=>reset
	);
	
-- NOP --
EM_pipeline_in(0) <= nop_exec or
							pc_r7_upd_stall or
							stall_lw;
-- WB|M control --
EM_pipeline_in(8 downto 1) <= RRE_pipeline_out(8 downto 1);

-- Dmem --
EM_pipeline_in(24 downto 9) <= dmem_exec;
-- RD --
rd_exec <= RRE_pipeline_out(40 downto 38);
EM_pipeline_in(27 downto 25) <= rd_exec;
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
memory_control_in(4 downto 0) <= EM_pipeline_out(8 downto 4);
memory_control_in(5) <= EM_pipeline_out(1);

memory_control: ControlWord  generic map (size=>6) port map
	(
		nop => EM_pipeline_out(0),
		cin => memory_control_in,
		cout(5) => wen_memory,
		cout(4) => zc_memory,
		cout(3) => outc_memory,
		cout(2) => mr_memory,
		cout(1) => mw_memory,
		cout(0) => lw_memory
	);

ad_memory <= EM_pipeline_out(43 downto 28);

data_ram1: data_ram port map
	(
		address => ad_memory(9 downto 0),
		data => EM_pipeline_out(24 downto 9),
		wren => mw_memory,			--------------------NOT SURE -----------need not always read if not writing?--------
		q => ram_dout,
		clock => clk
	);

ram_z <= '1' when (ram_dout = zero_16bit) else '0';
rd_memory <= EM_pipeline_out(27 downto 25);

MWB_pipeline: PipelineDataRegister port map
	(
		Din => MWB_pipeline_in,
		Dout => MWB_pipeline_out,
		enable => '1',---------NOT SURE-----------if always '1'---------
		clk => clk,
		reset=>reset
	);
	
c_memory <= EM_pipeline_out(44);
z_memory <= ram_z when zc_memory = '1' else
            EM_pipeline_out(45);
	
-- NOP --
MWB_pipeline_in(0) <= EM_pipeline_out(0) or pc_r7_upd_stall;
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
MWB_pipeline_in(40 downto 25) <= EM_pipeline_out(61 downto 46);


------------------ WRITEBACK STAGE ------------------

wb_control: ControlWord  generic map (size=>3) port map
	(
		nop => MWB_pipeline_out(0),
		cin => MWB_pipeline_out(3 downto 1),
		cout(0) => wen_writeback,
		cout(1) => cen_writeback,
		cout(2) => zen_writeback
	);
	
pcupd_block: pc_r7_update_block port map
   (
		nop_bit => MWB_pipeline_out(0),
		RD => MWB_pipeline_out(6 downto 4),
		WEN_in => wen_writeback,
		
		WEN_out => pc_r7_upd_wen_out,
		R7_upd => pcupd_r7upd,
		Stall => pc_r7_upd_stall
	);
	
creg: DataRegister port map (
			Din => MWB_pipeline_out(23 downto 23),
			Dout => ctmp_writeback,
			enable => cen_writeback,
			clk => clk,
			reset=>reset
		);

zreg: DataRegister port map (
			Din => MWB_pipeline_out(24 downto 24),
			Dout => ztmp_writeback,
			enable => zen_writeback,
			clk => clk,
			reset=>reset
		);
		
pc_writeback <= MWB_pipeline_out(40 downto 25);
d_writeback <= MWB_pipeline_out(22 downto 7);
rd_writeback <= MWB_pipeline_out(6 downto 4);

end architecture;
