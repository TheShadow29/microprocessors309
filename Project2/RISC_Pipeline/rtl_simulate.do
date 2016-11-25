transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/forwarding_unit.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/all_components.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/flag_forwarding.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/program_rom.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/data_ram.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/history_block.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/pc_r7_update_block.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/instruction_decoder.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/RISC_Pipeline.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/control_decoder.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/data_register.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/adder.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/regfile.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/control_word.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/priority_encoder.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/alu.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/muxes.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/decoder.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/vhd_files/data_path.vhd}

vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project2/RISC_Pipeline/testbenches/test_pipeline.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  test_pipeline

add wave *
add wave -position insertpoint  \
sim:/test_pipeline/dut/dp/clk \
sim:/test_pipeline/dut/dp/reset \
sim:/test_pipeline/dut/dp/start \
sim:/test_pipeline/dut/dp/done \
sim:/test_pipeline/dut/dp/pc_fetch_in \
sim:/test_pipeline/dut/dp/pc_fetch_out \
sim:/test_pipeline/dut/dp/pc_fetch_p1 \
sim:/test_pipeline/dut/dp/rom_data \
sim:/test_pipeline/dut/dp/history_pcout \
sim:/test_pipeline/dut/dp/pc_fetch_enable \
sim:/test_pipeline/dut/dp/FD_pipeline_en \
sim:/test_pipeline/dut/dp/history_bren \
sim:/test_pipeline/dut/dp/history_stall \
sim:/test_pipeline/dut/dp/const_ir_nop \
sim:/test_pipeline/dut/dp/FD_pipeline_in \
sim:/test_pipeline/dut/dp/FD_pipeline_out \
sim:/test_pipeline/dut/dp/opcode_irdecoder \
sim:/test_pipeline/dut/dp/ccode_irdecoder \
sim:/test_pipeline/dut/dp/ra_irdecoder \
sim:/test_pipeline/dut/dp/rb_irdecoder \
sim:/test_pipeline/dut/dp/rc_irdecoder \
sim:/test_pipeline/dut/dp/ninebithigh_irdecoder \
sim:/test_pipeline/dut/dp/imm_irdecoder \
sim:/test_pipeline/dut/dp/pc_decode_p1 \
sim:/test_pipeline/dut/dp/lmsm_imm_irdecoder \
sim:/test_pipeline/dut/dp/lhi_irdecoder \
sim:/test_pipeline/dut/dp/lmsm_irdecoder \
sim:/test_pipeline/dut/dp/jal_irdecoder \
sim:/test_pipeline/dut/dp/DRR_pipeline_en \
sim:/test_pipeline/dut/dp/DRR_pipeline_in \
sim:/test_pipeline/dut/dp/DRR_pipeline_out \
sim:/test_pipeline/dut/dp/a1_regread \
sim:/test_pipeline/dut/dp/a2_regread \
sim:/test_pipeline/dut/dp/PE_regread \
sim:/test_pipeline/dut/dp/regfile_d1 \
sim:/test_pipeline/dut/dp/regfile_d2 \
sim:/test_pipeline/dut/dp/PE_zp_regread \
sim:/test_pipeline/dut/dp/jlr_regread \
sim:/test_pipeline/dut/dp/a1c_regread \
sim:/test_pipeline/dut/dp/lmsm_regread \
sim:/test_pipeline/dut/dp/dmemc_regread \
sim:/test_pipeline/dut/dp/V_regread \
sim:/test_pipeline/dut/dp/a2c_regread \
sim:/test_pipeline/dut/dp/rdc_regread \
sim:/test_pipeline/dut/dp/Txn_regread \
sim:/test_pipeline/dut/dp/RRE_pipeline_in \
sim:/test_pipeline/dut/dp/RRE_pipeline_out \
sim:/test_pipeline/dut/dp/lhi_exec \
sim:/test_pipeline/dut/dp/pc1_exec \
sim:/test_pipeline/dut/dp/immc_exec \
sim:/test_pipeline/dut/dp/beq_exec \
sim:/test_pipeline/dut/dp/zflagc_exec \
sim:/test_pipeline/dut/dp/cflagc_exec \
sim:/test_pipeline/dut/dp/stall_beq \
sim:/test_pipeline/dut/dp/stall_lw \
sim:/test_pipeline/dut/dp/alu1_exec_stall \
sim:/test_pipeline/dut/dp/alu2_exec_stall \
sim:/test_pipeline/dut/dp/dmem_exec_stall \
sim:/test_pipeline/dut/dp/alu_c \
sim:/test_pipeline/dut/dp/alu_z \
sim:/test_pipeline/dut/dp/stall_flagfwd \
sim:/test_pipeline/dut/dp/nop_exec \
sim:/test_pipeline/dut/dp/aluc_exec \
sim:/test_pipeline/dut/dp/flagc_exec \
sim:/test_pipeline/dut/dp/alu1_exec \
sim:/test_pipeline/dut/dp/alu2_exec \
sim:/test_pipeline/dut/dp/dmem_exec \
sim:/test_pipeline/dut/dp/alu_in1 \
sim:/test_pipeline/dut/dp/alu_in2 \
sim:/test_pipeline/dut/dp/alu_out \
sim:/test_pipeline/dut/dp/pc_exec \
sim:/test_pipeline/dut/dp/pc_exec_p1 \
sim:/test_pipeline/dut/dp/EM_pipeline_in \
sim:/test_pipeline/dut/dp/EM_pipeline_out \
sim:/test_pipeline/dut/dp/mw_memory \
sim:/test_pipeline/dut/dp/mr_memory \
sim:/test_pipeline/dut/dp/lw_memory \
sim:/test_pipeline/dut/dp/outc_memory \
sim:/test_pipeline/dut/dp/zc_memory \
sim:/test_pipeline/dut/dp/c_memory \
sim:/test_pipeline/dut/dp/z_memory \
sim:/test_pipeline/dut/dp/ram_z \
sim:/test_pipeline/dut/dp/ram_dout \
sim:/test_pipeline/dut/dp/ad_memory \
sim:/test_pipeline/dut/dp/rd_memory \
sim:/test_pipeline/dut/dp/MWB_pipeline_in \
sim:/test_pipeline/dut/dp/MWB_pipeline_out \
sim:/test_pipeline/dut/dp/cen_writeback \
sim:/test_pipeline/dut/dp/zen_writeback \
sim:/test_pipeline/dut/dp/wen_writeback \
sim:/test_pipeline/dut/dp/pc_r7_upd_stall \
sim:/test_pipeline/dut/dp/pc_r7_upd_wen_out \
sim:/test_pipeline/dut/dp/pcupd_r7upd \
sim:/test_pipeline/dut/dp/ctmp_writeback \
sim:/test_pipeline/dut/dp/ztmp_writeback \
sim:/test_pipeline/dut/dp/rd_writeback \
sim:/test_pipeline/dut/dp/pc_writeback \
sim:/test_pipeline/dut/dp/d_writeback \
sim:/test_pipeline/dut/dp/zero_8bit \
sim:/test_pipeline/dut/dp/one_16bit \
sim:/test_pipeline/dut/dp/zero_16bit \
sim:/test_pipeline/dut/dp/register_file/R \
sim:/test_pipeline/dut/dp/register_file/D3 \
sim:/test_pipeline/dut/dp/register_file/A3 \
sim:/test_pipeline/dut/dp/register_file/WR

view structure
view signals

run 100ns
