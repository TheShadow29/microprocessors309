library ieee;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.ALL;	

library work;
use work.all_components.all;

entity iitb_risc is
	port (
		alui1, alui2: in std_logic_vector(15 downto 0);
		aluo: out std_logic_vector(15 downto 0);
		aluc: in std_logic;
		C,Z: out std_logic;
		
		D1,D2: out std_logic_vector(15 downto 0);
		D3: in std_logic_vector(15 downto 0);
		A1,A2,A3: in std_logic_vector(2 downto 0);
		
		clk, WR: in std_logic;
		
		tx : in std_logic_vector(7 downto 0);
		s : out std_logic_vector(2 downto 0);
		N : out std_logic
	);
end entity iitb_risc;

architecture Behave of iitb_risc is
begin

alu1: alu port map(X=>alui1,Y=>alui2,out_p=>aluo,op_code=>aluc,C=>C,Z=>Z);

regfile1: RegFile port map(D1=>D1, D2=>D2, D3=>D3, A1=>A1, A2=>A2, A3=>A3, clk=>clk, WR=>WR);

pri_enc : PriorityEncoder port map(x => tx, s=>s,N => N);

end architecture;