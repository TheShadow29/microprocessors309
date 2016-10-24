transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project1/IITB-RISC/vhd_files/all_components.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project1/IITB-RISC/vhd_files/memory_model.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project1/IITB-RISC/vhd_files/data_register_bin.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project1/IITB-RISC/vhd_files/decoder.vhdl}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project1/IITB-RISC/vhd_files/muxes.vhdl}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project1/IITB-RISC/vhd_files/regfile.vhdl}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project1/IITB-RISC/vhd_files/datareg.vhdl}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project1/IITB-RISC/vhd_files/alu.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project1/IITB-RISC/vhd_files/iitb_risc.vhdl}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project1/IITB-RISC/vhd_files/priority_encoder.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project1/IITB-RISC/vhd_files/control_path.vhd}
vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project1/IITB-RISC/vhd_files/data_path.vhd}

vcom -93 -work work {/media/udiboy/Data/Documents/IIT/EE/EE 337/projects/Project1/IITB-RISC/vhd_files/test_processor.vhdl}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv_hssi -L cycloneiv_pcie_hip -L cycloneiv -L rtl_work -L work -voptargs="+acc"  TestProcessor

add wave -position insertpoint sim:/testprocessor/dut/cp/curr_state
add wave -position insertpoint sim:/testprocessor/dut/dp1/ir/Dout
add wave -position insertpoint sim:/testprocessor/dut/dp1/eab
add wave -position insertpoint sim:/testprocessor/dut/dp1/pri_enc/*

add wave -position insertpoint sim:/testprocessor/dut/dp1/c1/Dout
add wave -position insertpoint sim:/testprocessor/dut/dp1/z1/Dout

add wave -position insertpoint sim:/testprocessor/dut/dp1/mem/address
add wave -position insertpoint sim:/testprocessor/dut/dp1/mem/data

add wave -position insertpoint sim:/testprocessor/dut/dp1/mem_rw

add wave -position insertpoint sim:/testprocessor/dut/dp1/regfile1/R(0)
add wave -position insertpoint sim:/testprocessor/dut/dp1/regfile1/R(1)
add wave -position insertpoint sim:/testprocessor/dut/dp1/regfile1/R(2)
add wave -position insertpoint sim:/testprocessor/dut/dp1/regfile1/R(3)
add wave -position insertpoint sim:/testprocessor/dut/dp1/regfile1/R(4)
add wave -position insertpoint sim:/testprocessor/dut/dp1/regfile1/R(5)
add wave -position insertpoint sim:/testprocessor/dut/dp1/regfile1/R(6)
add wave -position insertpoint sim:/testprocessor/dut/dp1/regfile1/R(7)
add wave -position insertpoint sim:/testprocessor/dut/dp1/regfile1/D1
add wave -position insertpoint sim:/testprocessor/dut/dp1/regfile1/D2
add wave -position insertpoint sim:/testprocessor/dut/dp1/regfile1/D3
add wave -position insertpoint sim:/testprocessor/dut/dp1/regfile1/A1
add wave -position insertpoint sim:/testprocessor/dut/dp1/regfile1/A2

view structures
view signals
run 3 us
