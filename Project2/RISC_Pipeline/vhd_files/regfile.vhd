library ieee;
	use ieee.std_logic_1164.all;
library work;
	use work.all_components.all;
	
entity RegFile is
	port(
		D1,D2: out std_logic_vector(15 downto 0);
		A1,A2,A3 :in std_logic_vector(2 downto 0);
		D3, PC:in std_logic_vector(15 downto 0);
		clk, WR, R7upd: in std_logic
	 );
end entity RegFile;

architecture Behave of RegFile is
	type RegArray is array (natural range <>) of std_logic_vector(15 downto 0);
	
	signal R: RegArray(7 downto 0);
	signal En: std_logic_vector(7 downto 0);
	signal WriteData: std_logic_vector(15 downto 0);
	signal WenDecoderEn, PCen: std_logic;
begin

WriteData <= PC when R7upd = '1' else
				 D3;

RegFile:
for I in 0 to 6 generate
	RegFileX: DataRegister port map (Dout=>R(I),Enable=>En(I),Din=>WriteData,clk=>clk);
end generate RegFile;

PCen <= R7upd or En(7);
PC: DataRegister port map (Dout=>R(7),Enable=>PCen,Din=>WriteData,clk=>clk);

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

WenDecoderEn <= WR and not(R7upd);
decoder: Decoder8 port map (A=>A3,O=>En,OE=>WenDecoderEn);

end Behave;
---------------------------