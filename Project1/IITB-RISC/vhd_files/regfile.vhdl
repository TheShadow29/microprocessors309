library ieee;
	use ieee.std_logic_1164.all;
library work;
	use work.all_components.all;
	
entity RegFile is
	port(
		D1,D2: out std_logic_vector(15 downto 0);
		A1,A2,A3 :in std_logic_vector(2 downto 0);
		D3 :in std_logic_vector(15 downto 0);
		clk: in std_logic
	 );
end entity RegFile;
architecture Behave of RegFile is
	type RegArray is array (natural range <>) of std_logic_vector(15 downto 0);
	type EnableArray is array (natural range <>) of std_logic;

	signal R: RegArray(7 downto 0);
	signal En: EnableArray(7 downto 0);
	signal d1mux1out,d2mux1out: RegArray(3 downto 0);
	signal d1mux2out,d2mux2out: RegArray(1 downto 0);
begin

RegFile:
for I in 0 to 7 generate
	RegFileX: DataRegister port map (Dout=>R(I),Enable=>En(I),Din=>D3,clk=>clk);
end generate RegFile;

D1MuxLayer1:
for I in 0 to 3 generate
	MuxLayer1X: bigmux port map (A=>R(2*I),B=>R(2*I+1),s=>A1(0),D=>d1mux1out(I));
end generate D1MuxLayer1;
D1MuxLayer2:
for I in 0 to 1 generate
	MuxLayer2X: bigmux port map (A=>d1mux1out(2*I),B=>d1mux1out(2*I+1),s=>A1(1),D=>d1mux2out(I));
end generate D1MuxLayer2;
D1Mux3: bigmux port map (A=>d1mux2out(0),B=>d1mux2out(1),s=>A1(2),D=>D1);

D2MuxLayer1:
for I in 0 to 3 generate
	MuxLayer1X: bigmux port map (A=>R(2*I),B=>R(2*I+1),s=>A2(0),D=>d2mux1out(I));
end generate D2MuxLayer1;
D2MuxLayer2:
for I in 0 to 1 generate
	MuxLayer2X: bigmux port map (A=>d2mux1out(2*I),B=>d2mux1out(2*I+1),s=>A2(1),D=>d2mux2out(I));
end generate D2MuxLayer2;
D2Mux3: bigmux port map (A=>d2mux2out(0),B=>d2mux2out(1),s=>A2(2),D=>D2);

En(0) <= not(A3(0)) and not(A3(1)) and not(A3(2));
En(1) <= A3(0) and not(A3(1)) and not(A3(2));
En(2) <= not(A3(0)) and A3(1) and not(A3(2));
En(3) <= A3(0) and A3(1) and not(A3(2));
En(4) <= not(A3(0)) and not(A3(1)) and A3(2);
En(5) <= A3(0) and not(A3(1)) and A3(2);
En(6) <= not(A3(0)) and A3(1) and A3(2);
En(7) <= A3(0) and A3(1) and A3(2);

end Behave;
---------------------------