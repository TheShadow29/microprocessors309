library ieee;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;	

library work;
use work.all_components.all;

entity iitb_risc is
	port (
		prog_en,test_en: in std_logic;
		prog_addr: in std_logic_vector(15 downto 0);
		prog_data: inout std_logic_vector(15 downto 0);
				
		start, clk, reset: in std_logic;
		done : out std_logic
	);
end entity iitb_risc;

architecture Behave of iitb_risc is
		signal alu_control, a2_mux_c, t1_mux_c, t3_w_c, ir_w_c, di_w_c, do_w_c, do_mux_c, V: std_logic;
		signal carry_flag,zero_flag, do_xor_c, car_w_c, zer_w_c, uc_rw_c: std_logic;
		signal a1_mux_c, d3_mux_c, a0_mux_c, tx_mux_c, condition_code:  std_logic_vector(1 downto 0);
		signal a3_mux_c , t2_mux_c:  std_logic_vector(2 downto 0);
		signal op_code :  std_logic_vector(3 downto 0);
begin

cp : control_path port map 
		(
			alu_control => alu_control,
			a1_mux_c => a1_mux_c,
			a2_mux_c => a2_mux_c,
			a3_mux_c => a3_mux_c,
			t1_mux_c => t1_mux_c,
			t2_mux_c => t2_mux_c,
			t3_w_c => t3_w_c, 
			d3_mux_c => d3_mux_c, 
			a0_mux_c => a0_mux_c,
			ir_w_c => ir_w_c,
			di_w_c => di_w_c,
			do_mux_c => do_mux_c, 
			do_w_c => do_w_c,
			tx_mux_c => tx_mux_c,
			clk => clk, 
			reset => reset,
			op_code => op_code,
			condition_code => condition_code,
			carry_flag => carry_flag,
			zero_flag => zero_flag,
			car_w_c => car_w_c,
			zer_w_c => zer_w_c,
			start => start,
			done => done,
			V => V,
			uc_w_c => uc_rw_c,
			do_xor_c => do_xor_c
		);
		
dp1 : data_path port map 
		(
			prog_addr => prog_addr,
			prog_data => prog_data, 
			prog_en => prog_en,
			test_en => test_en,
			carry_flag => carry_flag,
			zero_flag => zero_flag,
			op_code => op_code,
			condition_code => condition_code,
			a1_mux_c => a1_mux_c,
			a2_mux_c => a2_mux_c,
			a3_mux_c => a3_mux_c,
			t1_mux_c => t1_mux_c,
			t2_mux_c => t2_mux_c,
			t3_w_c => t3_w_c, 
			d3_mux_c => d3_mux_c, 
			a0_mux_c => a0_mux_c,
			ir_w_c => ir_w_c,
			di_w_c => di_w_c,
			do_mux_c => do_mux_c, 
			do_w_c => do_w_c,
			tx_mux_c => tx_mux_c, 
			car_w_c => car_w_c,
			zer_w_c => zer_w_c,
			alu_op_code => alu_control,
			clk => clk, 
			reset => reset,
			N => V,
			uc_rw_c => uc_rw_c,
			do_xor_c => do_xor_c
		);
		

end architecture Behave;