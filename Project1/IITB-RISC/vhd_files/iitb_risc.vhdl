library ieee;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;	

library work;
use work.all_components.all;

entity iitb_risc is
	port (
		prog_en: in std_logic;
		prog_addr: in std_logic_vector(15 downto 0);
		prog_data: in std_logic_vector(15 downto 0);
		
		control_vector: in std_logic_vector(19 downto 0);
		
		start, done, clk: in std_logic
	);
end entity iitb_risc;

architecture Behave of iitb_risc is
	signal alui1, alui2, aluo: std_logic_vector(15 downto 0);
	signal aluc,C,Z: std_logic;
		
	signal D1,D2,D3: std_logic_vector(15 downto 0);
	signal A1,A2,A3: std_logic_vector(2 downto 0);
	signal RF_WE: std_logic;
		
	signal pe: std_logic_vector(2 downto 0);
	signal N: std_logic;
		
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
	
	signal a1_c,do_c,ao_c,T_c: std_logic;
	signal a3_c,d3_c,t1_c,t2_c: std_logic_vector(1 downto 0);
	
	signal zero: std_logic_vector(15 downto 0) := (others=>'0');
begin

-- Components
alu1: alu port map(X=>alui1,Y=>alui2,out_p=>aluo,op_code=>aluc,C=>C,Z=>Z);
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

di: DataRegister port map (Din=>mem_data,Dout=>di_out,enable=>di_w,clk=>clk);
do: DataRegister port map (Din=>do_in,Dout=>edb,enable=>do_w,clk=>clk);
ao: DataRegister port map (Din=>ao_in,Dout=>eab,enable=>ao_w,clk=>clk);
ir: DataRegister port map (Din=>mem_data,Dout=>ir_out,enable=>ir_w,clk=>clk);

-- Data path connection muxes
ra<=ir_out(11 downto 9);
rb<=ir_out(8 downto 6);
rc<=ir_out(5 downto 3);

a1_mux: mux2 port map 
			(A0=>ra,A1=>rb,
			 s=>a1_c,
			 D=>a1);
a1_c <= control_vector(0);

a2<=rb; -- A2 needs no control because directly connected to RB

a3_mux: mux4 port map
			(A0=>ra,A1=>rb,A2=>rc,A3=>pe,
			 s=>a3_c,
			 D=>a3);
a3_c <= control_vector(2 downto 1);
			 
d3_mux: mux4 port map
			(A0=>di_out,A1=>d1,A2=>t3_out,A3=>zero,
			 s=>d3_c,
			 D=>d3);
d3_c <= control_vector(4 downto 3);
RF_WE <= control_vector(5); -- Register file write enable
			 
t1_mux: mux4 port map
			(A0=>d1,A1=>di_out,A2=>T_out,A3=>zero,
			 s=>t1_c,
			 D=>t1_in);
t1_c <= control_vector(7 downto 6);
t1_w <= control_vector(6);

t2_mux: mux4 port map
			(A0=>d2,
			 A1=>std_logic_vector(resize(unsigned(pe),16)),
			 A2=>std_logic_vector(resize(unsigned(ir_out(8 downto 0)),16)),
			 A3=>std_logic_vector(resize(unsigned(ir_out(5 downto 0)),16)),
			 s=>t2_c,
			 D=>t2_in);
t2_c <= control_vector(10 downto 9);
t2_w <= control_vector(11);

do_mux: mux2 port map
			(A0=>d1,A1=>t3_out,
			 s=>do_c,
			 D=>do_in);
do_c <= control_vector(12);
do_w <= control_vector(13);
			 
ao_mux: mux2 port map
			(A0=>d1,A1=>t3_out,
			 s=>ao_c,
			 D=>ao_in);
ao_c <= control_vector(14);
ao_w <= control_vector(15);

T_mux: mux2 port map
			(A0=>ir_out(7 downto 0),A1=>Tn,
			 s=>T_c,
			 D=>T_in);
T_c <= control_vector(16);
T_w <= control_vector(17);

di_w <= control_vector(18); -- edb -> di
ir_w <= control_vector(19); -- edb -> ir
end architecture Behave;