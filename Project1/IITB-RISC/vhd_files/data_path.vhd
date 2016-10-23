library ieee;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;	

library work;
use work.all_components.all;

entity data_path is
	port 
	(
		prog_en: in std_logic;
		prog_addr: in std_logic_vector(15 downto 0);
		prog_data: in std_logic_vector(15 downto 0);
		a1_mux_c : in std_logic_vector(1 downto 0);
		a2_mux_c : in std_logic;
		a3_mux_c : in std_logic_vector(2 downto 0);
		t1_mux_c : in std_logic;
		t2_mux_c : in std_logic_vector(2 downto 0);
		t3_w_c : in std_logic;
		a0_mux_c : in std_logic_vector(1 downto 0);
		ir_w_c : in std_logic;
		di_w_c : in std_logic;
		do_mux_c : in std_logic;
		do_w_c : in std_logic;
		d3_mux_c : in std_logic_vector(1 downto 0);
		tx_mux_c : in std_logic_vector(1 downto 0);
		car_w_c : in std_logic;
		zer_w_c : in std_logic;
		do_xor_c : in std_logic;
		carry_flag : out std_logic;
		zero_flag : out std_logic;
		alu_op_code : in std_logic;
		clk, reset : in std_logic;
		uc_rw_c : in std_logic;
		op_code : out std_logic_vector(3 downto 0);
		condition_code : out std_logic_vector(1 downto 0);
		N : out std_logic
	);
end entity;

architecture data of data_path is
		signal alui1, alui2, aluo: std_logic_vector(15 downto 0);
	signal aluc,C,Z: std_logic;
		
	signal D1,D2,D3: std_logic_vector(15 downto 0);
	signal A1,A2,A3: std_logic_vector(2 downto 0);
	signal RF_WE: std_logic;
		
	signal pe: std_logic_vector(2 downto 0);
		
	signal mem_addr,mem_data, eab,edb: std_logic_vector(15 downto 0);
	signal mem_rw, uc_rw: std_logic;
	
	signal t1_in,t2_in,t3_in,t3_out,
			 ao_in,
			 di_in,di_out,do_in,do_out,
			 ir_out: std_logic_vector(15 downto 0) := (others=>'0');
	signal T_in,T_out, Tn: std_logic_vector(7 downto 0) := (others=>'0');
	signal t1_w,t2_w,t3_w,
			 ao_w,
			 di_w,do_w,
			 ir_w,T_w: std_logic := '0';
			 
	signal ra,rb,rc: std_logic_vector(2 downto 0);
	--signal carry_flag, zero_flag: std_logic;
	signal car_w, zer_w : std_logic;
	
	signal do_c,ao_c,T_c, a2_c, t1_c: std_logic;
	signal a1_c : std_logic_vector(1 downto 0);
	signal d3_c: std_logic_vector(1 downto 0);
	signal a3_c, t2_c : std_logic_vector(2 downto 0);
	
	constant zero: std_logic_vector(15 downto 0) := (others=>'0');
	signal nine_bit_high : std_logic_vector(15 downto 0) := (others => '0');
	constant const_7 : std_logic_vector(2 downto 0):= (others => '1');
	
	constant const_1_16bit : std_logic_vector(15 downto 0) := (0 => '1', others => '1');
	constant zero_3_bit : std_logic_vector(2 downto 0) := (others => '0');

	constant highZ : std_logic_vector(2 downto 0) := (others => 'Z');
begin

-- Components
alu1: alu port map(X=>alui1,Y=>alui2,out_p=>aluo,op_code=>aluc,do_xor => do_xor_c, C=>C,Z=>Z);
regfile1: RegFile port map(D1=>D1, D2=>D2, D3=>D3, A1=>A1, A2=>A2, A3=>A3, clk=>clk, WR=>RF_WE);
pri_enc : PriorityEncoder port map(x => T_out, s=>pe,N => N, Tn=>Tn);
mem : memory_model port map (clk => clk, rw => mem_rw, address => mem_addr, data => mem_data);

-- Program mode muxes
mem_addr_mux: mux2 port map (A0=>eab,A1=>prog_addr,s=>prog_en,D=>mem_addr);
mem_data_mux: mux2 port map (A0=>edb,A1=>prog_data,s=>prog_en,D=>mem_data);
mem_rw <= prog_en or uc_rw; -- Mux hai

-- Registers
t1: DataRegister port map (Din=>t1_in,Dout=>alui1,enable=>t1_w,clk=>clk);
t2: DataRegister port map (Din=>t2_in,Dout=>alui2,enable=>t2_w,clk=>clk);
t3: DataRegister port map (Din=>aluo,Dout=>t3_out,enable=>t3_w,clk=>clk);
T: DataRegister port map (Din=>T_in,Dout=>T_out,enable=>T_w,clk=>clk);

di: DataRegister port map (Din=>edb,Dout=>di_out,enable=>di_w,clk=>clk);
do: DataRegister port map (Din=>do_in,Dout=>edb,enable=>do_w,clk=>clk);
ao: DataRegister port map (Din=>ao_in,Dout=>eab,enable=>ao_w,clk=>clk);
ir: DataRegister port map (Din=>edb,Dout=>ir_out,enable=>ir_w,clk=>clk);

c1: data_register_bin port map (Din => C, Dout => carry_flag, enable => car_w, clk => clk);
z1: data_register_bin port map (Din => Z, Dout => zero_flag, enable => zer_w, clk => clk);

-- Data path connection muxes
ra<=ir_out(11 downto 9);
rb<=ir_out(8 downto 6);
rc<=ir_out(5 downto 3);
nine_bit_high(15 downto 7) <= ir_out(8 downto 0);


aluc <= alu_op_code;
car_w <= car_w_c;
zer_w <= zer_w_c;

op_code <= ir_out(15 downto 12);
condition_code <= ir_out(1 downto 0);

a1_mux: mux4 port map 
			(A0=>pe ,A1=>rb,A2 =>ra, A3 => const_7,
			 s=>a1_c,
			 D=>a1);
a1_c <= a1_mux_c;

--a2<=rb; -- A2 needs no control because directly connected to RB
a2_mux : mux2 port map 
			(A0 => ra, A1 => rb, s=> a2_c, D=>a2);
a2_c <= a2_mux_c;


a3_mux: mux8 port map
			(A0=>ra,A1=>rb,A2=>rc,A3=>const_7,A4 => pe, A5 => zero_3_bit, A6 => zero_3_bit, A7 => zero_3_bit,
			 s=>a3_c,
			 D=>a3);
a3_c <= a3_mux_c;
			 
d3_mux: mux4 port map
			(A0=>di_out,A1=>d1,A2=>t3_out,A3=>nine_bit_high,
			 s=>d3_c,
			 D=>d3);
d3_c <= d3_mux_c;
RF_WE <= a3_mux_c(0) or a3_mux_c(1) or a3_mux_c(2); -- Register file write enable
			 
--t1_mux: mux4 port map
--			(A0=>d1,A1=>di_out,A2=>T_out,A3=>zero,
--			 s=>t1_c,
--			 D=>t1_in);
--t1_c <= control_vector(7 downto 6);
--t1_w <= control_vector(6);

t1_mux : mux2 port map 
			(A0 => zero, A1 => d1, s=> t1_c, D => t1_in);
t1_c <= t1_mux_c;
t1_w <= t1_mux_c;

t2_mux: mux8 port map
			(
				A7 => zero,
				A6 => zero,
				A5=>std_logic_vector(resize(unsigned(pe),16)),
				A4 => d2, 
				A3 => const_1_16bit, 
				A2 => std_logic_vector(resize(unsigned(ir_out(5 downto 0)),16)),
				A1 => std_logic_vector(resize(unsigned(ir_out(8 downto 0)),16)),
				A0 => zero, 
				s => t2_c,
				D => t2_in
			);
t2_c <= t2_mux_c;
t2_w <= t2_mux_c(0) or t2_mux_c(1) or t2_mux_c(2);

t3_w <= t3_w_c;

do_mux: mux2 port map
			(A0=>d1,A1=>t3_out,
			 s=>do_c,
			 D=>do_in);
do_c <= do_mux_c;
do_w <= do_w_c;
			 
ao_mux: mux2 port map
			(A0=>d1,A1=>t3_out,
			 s=>ao_c,
			 D=>ao_in);
ao_c <= a0_mux_c(0);
ao_w <= a0_mux_c(1);

T_mux: mux2 port map
			(A0=>ir_out(7 downto 0),A1=>Tn,
			 s=>T_c,
			 D=>T_in);
T_c <= tx_mux_c(0);
T_w <= tx_mux_c(1);

di_w <= di_w_c; -- edb -> di
--ir_w <= control_vector(19); -- edb -> ir
ir_w <= ir_w_c;
uc_rw <= uc_rw_c;
end architecture;
