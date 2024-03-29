library ieee;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;	

library work;
use work.all_components.all;

entity control_path is
	port
	(
		alu_control : out std_logic;
		a1_mux_c : out std_logic_vector(1 downto 0);
		a2_mux_c : out std_logic;
		a3_mux_c : out std_logic_vector(2 downto 0);
		t1_mux_c : out std_logic;
		t2_mux_c : out std_logic_vector(2 downto 0);
		t3_w_c : out std_logic;
		d3_mux_c : out std_logic_vector(1 downto 0);
		a0_mux_c : out std_logic_vector(1 downto 0);
		ir_w_c : out std_logic;
		di_w_c : out std_logic;
		do_mux_c : out std_logic;
		do_w_c : out std_logic;
		tx_mux_c : out std_logic_vector(1 downto 0);
		do_xor_c : out std_logic;
		car_w_c : out std_logic;
		zer_w_c : out std_logic;
		uc_w_c : out std_logic;
		clk, reset : in std_logic;
		op_code : in std_logic_vector(3 downto 0);
		condition_code : in std_logic_vector(1 downto 0);
		V : in std_logic;
		carry_flag : in std_logic;
		zero_flag : in std_logic;
		start : in std_logic;
		done : out std_logic
	);
end entity;

architecture control of control_path is
	type fsm_state is 
		(rst,
		s0,	
		s1,	-- ra -> a1, rb -> a2, d1 -> t1, d2 -> t2
		s2,
		s3,
		s4,
		s5,
		s6,
		s7,
		s8,
		s9,
		s10,
		s11,
		s12,
		s13,
		s14,
		s15,
		s16,
		s17,
		s18,
		s19,
		s20,
		s21,
		s22,
		s23,
		s24,
		s25,
		s26,
		s27,
		s28);
		
	signal curr_state : fsm_state := rst;
begin
	process(start, curr_state, zero_flag, carry_flag, clk, reset, V, op_code, condition_code)
		variable next_state : fsm_state;
		--variable Tvar : std_logic_vector(19 downto 0);
		variable a1_mux_var : std_logic_vector(1 downto 0);
		variable	a2_mux_var : std_logic;
		variable a3_mux_var : std_logic_vector(2 downto 0);
		variable t1_mux_var : std_logic;
		variable t2_mux_var : std_logic_vector(2 downto 0);
		variable t3_w_var : std_logic;
		variable d3_mux_var : std_logic_vector(1 downto 0);
		variable a0_mux_var : std_logic_vector(1 downto 0);
		variable done_var : std_logic;
		variable alu_c_var : std_logic;
		variable ir_w_var : std_logic;
		variable di_w_var : std_logic;
		variable do_mux_var : std_logic;
		variable do_w_var : std_logic;
		variable tx_mux_var : std_logic_vector(1 downto 0);
		variable do_xor_var : std_logic;
		variable car_w_var : std_logic;
		variable zer_w_var: std_logic;
		variable uc_w_var : std_logic;
		begin
			next_state := curr_state;
			car_w_var := '0';
			zer_w_var := '0';
			done_var := '0';
			a1_mux_var := (others => '0');
			a2_mux_var := '0';
			a3_mux_var := (others => '0');
			a0_mux_var := "00";
			t1_mux_var := '0';
			t2_mux_var := (others => '0');
			t3_w_var := '0';
			d3_mux_var := (others => '0');
			di_w_var := '0';
			do_w_var := '0';
			do_mux_var := '0';
			ir_w_var := '0';
			tx_mux_var := "00";
			alu_c_var := '0';
			do_xor_var := '0';
			uc_w_var := '0';
			
			
			case curr_state is
				when rst =>
					if start = '1'
					then
						ir_w_var := '1';
						next_state := s0;
					end if;
				when s0 =>
					if (op_code = "0000" or op_code = "0010") then -- ADD/NDU
						if (condition_code = "00") then -- ADD/NDU
							next_state := s1;
						elsif (condition_code="01") then 
							if (zero_flag = '1') then --ADZ/NDZ
								next_state := s1;
							else
								next_state := s5;
							end if;
						elsif (condition_code = "10") then
							if (carry_flag = '1') then -- ADC/NDC
								next_state := s1;
							else
								next_state := s5;
							end if;
						end if;
					elsif (op_code = "0001") then --ADI
						next_state := s7;
					elsif (op_code = "0011") then --LHI
						next_state := s9;
					elsif (op_code = "0100") then--LW
						next_state := s10;
					elsif (op_code = "0101") then--SW
						next_state := s13;
					elsif (op_code = "1100") then--BEq
						next_state := s1;
					elsif (op_code = "1000" or op_code = "1001") then --JAL or JLR
						next_state := s5;
					elsif (op_code = "0110" or op_code = "0111") then --LM or SM
						next_state := s20;
					elsif (op_code = "1111" ) then -- EXIT program
						done_var := '1';
						next_state := rst;
					end if;
				when s1 =>
--					alu_c_var := '0';
					a1_mux_var := "10";	--ra -> a1
					a2_mux_var := '1';	--rb -> a2
					t1_mux_var := '1';	--d1 -> t1
					t2_mux_var := "100";	--d2 -> t2
					next_state := s2;
					if (op_code = "1100") then	--beq
						next_state := s6;
						
					end if;
					
				when s2 =>
					a1_mux_var := "11";	--f1, +7 -> a1
					t1_mux_var := '1';	--d1 -> t1
					t2_mux_var := "011";	--+1 -> t2
					t3_w_var := '1';		--alu -> t3
					--need state_signals to decide next state
					if (op_code = "0000") then--add
						alu_c_var := '0';
						car_w_var := '1';
						zer_w_var := '1';
						next_state := s3;
					elsif (op_code = "0010") then--nand
						alu_c_var := '1';
						zer_w_var := '1';	--nand sets the zero flag
						--car_w_var := '1';	
						next_state := s3;
					elsif(op_code = "0001") then--adi
						alu_c_var := '0';
						car_w_var := '1';
						zer_w_var := '1';
						next_state := s8;
					elsif(op_code = "0100") then--lw
						next_state := s11;
					elsif(op_code = "0101") then--sw
						next_state := s14;
--					elsif(op_code = "1100") --beq
						--if alu operation done
--						if (zero_flag = '1')
--							next_state := s15;
--						else
--							next_state := s6;
--						end if;
						
					end if;
				
				when s3 => 
					a3_mux_var := "010";	--rc -> a3
					d3_mux_var := "10";	--t3 -> d3
					t3_w_var := '1';		--alu -> t3
					next_state := s4;
				
				when s4 =>
					a0_mux_var := "11"; 	--f2, t3 -> a0
					d3_mux_var := "10"; 	--t3 -> d0
					a3_mux_var := "011";	--+7 -> a3
					ir_w_var := '1';	--edb -> ir
					--done_var := '1';
					next_state := s0;
				
				when s5 =>
					a1_mux_var := "11";	--f1, +7 -> a1
					t1_mux_var := '1';	--d1 -> t1
					t2_mux_var := "011";	--+1 -> t2
					next_state := s6;
					if (op_code = "0000" or op_code = "0010") then
						if (condition_code = "10" or condition_code = "01") then
							next_state := s6;
						end if;
					elsif (op_code = "1100") then--beq
						if (zero_flag = '1') then
							next_state := s15;
						else
							next_state := s26;
						end if;
					elsif (op_code = "1000") then--JAL
						next_state := s16;
					elsif (op_code = "1001") then--JLR
						next_state := s18;
					end if;
					
					
				when s6 =>
					t3_w_var := '1';
					next_state := s4;					
					if (op_code = "1100") then--beq
						next_state := s5;
						zer_w_var := '1';
						do_xor_var := '1';
					elsif (op_code = "0001") then
						alu_c_var := '0';
					elsif (op_code = "0110") then--lm
						alu_c_var := '0';
						next_state := s4;
					elsif (op_code = "0100") then --lw
						alu_c_var := '0';
						zer_w_var := '1';
						next_state := s25;
					end if;
				
				when s7 =>
					a1_mux_var := "10"; --ra -> a1
					t1_mux_var := '1';	--d1 -> t1
					t2_mux_var := "010";	--6bi -> t2
					next_state := s2;
				
				when s8 =>
					d3_mux_var := "10";	--t3 ->d3
					a3_mux_var := "001";	--rb->a3
					t3_w_var := '1';		--alu ->t3
					next_state := s4;
				
				when s9 =>
					d3_mux_var := "11";	--9bh -> d3
					a3_mux_var := "101";	--ra -> a3
					a1_mux_var := "11";	--f1, +7 -> a1
					t1_mux_var := '1';	--d1 -> t1
					t2_mux_var := "011";	--+1 -> t2
					next_state := s6;
				
				when s10 =>
					a1_mux_var := "01";	--rb -> a1
					t1_mux_var := '1';	--d1 ->t1
					t2_mux_var := "010"; --6bi -> t2
					next_state := s6;
				
				when s11 =>
					a0_mux_var := "11";	--t3 -> a0
					di_w_var := '1';		--edb -> di
					if (op_code = "0100") then
						next_state := s12;
					elsif (op_code = "0110") then	--LM
						next_state := s22;
					end if;
					
				when s12 =>
					d3_mux_var := "01";	--di -> d3
					a3_mux_var := "101"; --ra -> a3
					t3_w_var := '1';
					next_state := s4;		
					alu_c_var := '0';
					zer_w_var := '1'; -- LW set zero flag
					next_state := s4;
				
				when s13 => 
					a1_mux_var:= "01"; --rb -> a1
					a2_mux_var := '0'; --ra -> a2
					t1_mux_var := '1'; --d1 -> t1
					t2_mux_var := "010"; --6bi -> t2
					do_mux_var := '1';	--d2 ->d0
					do_w_var := '1'; --enable write signal on do
					next_state := s2;
				
				when s14 =>
					a0_mux_var := "11"; --t3 -> a0
					uc_w_var := '1'; 	--do -> edb
					t3_w_var := '1';	--alu -t3
					next_state := s4;
				
				when s15 =>
					a1_mux_var := "11"; --+7 -> a1
					t1_mux_var := '1';	--d1 ->t1
					t2_mux_var := "010"; --d2 -> t2
					next_state := s26;
					
				when s16 =>
					t3_w_var := '1';	--alu -> t3
					a1_mux_var := "11";	--+7 -> a1
					t1_mux_var := '1'; 	--d1 -> t1
					t2_mux_var := "001"; --9bi -> t2
					next_state := s17;
					
				when s17 => 
					d3_mux_var := "10"; 	--t3 -> d3
					a3_mux_var := "101"; --ra -> a3
					t3_w_var := '1';
					next_state := s4;
					
				when s18 =>
					t3_w_var := '1';	--alu_wait
					a1_mux_var := "01";	--rb -> a1
					d3_mux_var := "00"; --d1 -> d3
					a0_mux_var := "10"; --d1 -> a0
					a3_mux_var := "011"; --+7 -> a3
					next_state := s19;
					
				when s19 => 
					d3_mux_var := "11"; --t3 -> d3
					a3_mux_var := "101"; --ra -> a3
					a1_mux_var := "11"; --+7 -> a1
					a0_mux_var := "10"; --d1 -> a0
					ir_w_var := '1';	--edb -> ir
					next_state := s0;
					
				when s20 => 
					tx_mux_var := "10"; --ir -> tx
					next_state := s28;
				
				when s21 => 
					t2_mux_var:= "101"; --LO16 -> t2
					a1_mux_var := "10";	--ra -> t1
					t1_mux_var := '1';	--d1 -> t1
					if (op_code = "0110") then	--LM	
						next_state := s27;
					elsif (op_code = "0111") then	--SM
						next_state := s23;
					end if;
					
				when s22 => 
					a3_mux_var := "100"; --lo -> a3
					d3_mux_var := "01"; --di -> d3
					tx_mux_var := "11";	--tnx -> tx
					next_state := s28;
					
				when s23 =>
					t3_w_var := '1';
					a1_mux_var := "00"; -- LO -> a1
					do_mux_var := '0';
					do_w_var := '1';	--enable write signal on do
					next_state := s24;
					
				when s24 =>
					a0_mux_var := "11"; --t3 -> a0
					uc_w_var := '1';	--do -> edb
					tx_mux_var := "11"; --tn -> tx
					next_state := s28;
					
				when s25 =>
					a0_mux_var := "11";	--t3 -> a0
					di_w_var := '1';		--edb -> di
					a1_mux_var := "11";	--f1, +7 -> a1
					t1_mux_var := '1';	--d1 -> t1
					t2_mux_var := "011";	--+1 -> t2
					next_state := s12;	
			
				when s26 =>
					t3_w_var := '1';
					next_state := s4;	
					
				when s27 => -- ALU lm/sm
					t3_w_var := '1';
					next_state := s11;	
					
				when s28 => -- branch lm/sm
					if (V = '0') then
						next_state := s5;
					else
						next_state := s21;
					end if;
					
			end case;
			
			--transition_signals(19 downto 0) <= Tvar(19 downto 0);
			done <= done_var;
			alu_control <= alu_c_var;
			a1_mux_c <= a1_mux_var;
			a2_mux_c <= a2_mux_var;
			a3_mux_c <= a3_mux_var;
			t1_mux_c <= t1_mux_var;
			t2_mux_c <= t2_mux_var;
			t3_w_c <= t3_w_var;
			d3_mux_c <= d3_mux_var;
			a0_mux_c <= a0_mux_var;
			ir_w_c <= ir_w_var;
			di_w_c <= di_w_var;
			do_mux_c <= do_mux_var;
			do_w_c <= do_w_var;
			tx_mux_c <= tx_mux_var;
			do_xor_c <= do_xor_var;
			car_w_c <= car_w_var;
			zer_w_c <= zer_w_var;
			uc_w_c <= uc_w_var;
			if(clk'event and (clk = '0')) then
				if(reset = '1') then
           		  curr_state <= rst;
        		else
             		curr_state <= next_state;
        		end if;
    		end if;
			
	end process;
		
end architecture;











