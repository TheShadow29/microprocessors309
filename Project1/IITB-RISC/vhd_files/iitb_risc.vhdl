library ieee;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.ALL;	

library work;
use work.all_components.all;

entity iitb_risc is
	port (
		prog_en: in std_logic;
		prog_addr: in std_logic_vector(15 downto 0);
		prog_data: inout std_logic_vector(15 downto 0);
		
		start, done, clk: in std_logic
	);
end entity iitb_risc;

architecture Behave of iitb_risc is
	signal alui1, alui2, aluo: std_logic_vector(15 downto 0);
	signal aluc,C,Z: std_logic;
		
	signal D1,D2,D3: std_logic_vector(15 downto 0);
	signal A1,A2,A3: std_logic_vector(2 downto 0);
	signal RF_WE: std_logic;
		
	signal tx: std_logic_vector(7 downto 0);
	signal s: std_logic_vector(2 downto 0);
	signal N: std_logic;
		
	signal mem_addr,mem_data: std_logic_vector(15 downto 0);
	signal mem_rw: std_logic;
	
	signal t1_in,t1_out,t2_in,t2_out,t3_in,t3_out,
			 ao_in,ao_out,
			 di_in,di_out,do_in,do_out,
			 ir_in,ir_out,T_in,T_out: std_logic_vector(15 downto 0) := (others=>'0');
	signal t1_w,t2_w,t3_w,
			 ao_w,
			 di_w,do_w,
			 ir_w,T_w: std_logic := '0';
	
begin

-- Components
alu1: alu port map(X=>alui1,Y=>alui2,out_p=>aluo,op_code=>aluc,C=>C,Z=>Z);
regfile1: RegFile port map(D1=>D1, D2=>D2, D3=>D3, A1=>A1, A2=>A2, A3=>A3, clk=>clk, WR=>RF_WE);
pri_enc : PriorityEncoder port map(x => tx, s=>s,N => N);
mem : memory_model port map (clk => clk, rw => mem_rw, address => mem_addr, data => mem_data);

-- Registers
t1: DataRegister(Din=>t1_in,Dout=>t1_out,enable=>t1_w,clk=>clk);
t2: DataRegister(Din=>t2_in,Dout=>t2_out,enable=>t2_w,clk=>clk);
t3: DataRegister(Din=>t3_in,Dout=>t3_out,enable=>t3_w,clk=>clk);
T: DataRegister(Din=>T_in,Dout=>T_out,enable=>T_w,clk=>clk);

di: DataRegister(Din=>di_in,Dout=>di_out,enable=>di_w,clk=>clk);
do: DataRegister(Din=>do_in,Dout=>do_out,enable=>do_w,clk=>clk);
ao: DataRegister(Din=>ao_in,Dout=>ao_out,enable=>ao_w,clk=>clk);
ir: DataRegister(Din=>ir_in,Dout=>ir_out,enable=>ir_w,clk=>clk);

-- Data path connection muxes


end architecture;