library ieee;
	use ieee.std_logic_1164.all;
library work;
	use work.all_components.all;
	
entity RegFile is
	port(
		D1,D2: out std_logic_vector(15 downto 0);
		A1,A2,A3 :in std_logic_vector(2 downto 0);
		D3 :in std_logic_vector(15 downto 0);
		clk, WR: in std_logic
	 );
end entity RegFile;
architecture Behave of RegFile is
	type RegArray is array (natural range <>) of std_logic_vector(15 downto 0);
	
	signal R: RegArray(7 downto 0);
	signal En: std_logic_vector(7 downto 0);
begin

RegFile:
for I in 0 to 7 generate
	RegFileX: DataRegister port map (Dout=>R(I),Enable=>En(I),Din=>D3,clk=>clk);
end generate RegFile;

D1Mux: mux8 port map (A0=>R(0),
							 A1=>R(1),
							 A2=>R(2),
							 A3=>R(3),
							 A4=>R(4),
							 A5=>R(5),
							 A6=>R(6),
							 A7=>R(7),
							 s=>A1,
							 D=>D1);
							 
D2Mux: mux8 port map (A0=>R(0),
							 A1=>R(1),
							 A2=>R(2),
							 A3=>R(3),
							 A4=>R(4),
							 A5=>R(5),
							 A6=>R(6),
							 A7=>R(7),
							 s=>A2,
							 D=>D2);

decoder: Decoder8 port map (A=>A3,O=>En,OE=>WR);

end Behave;
---------------------------