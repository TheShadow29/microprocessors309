library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

library work;
	use work.all_components.all;

entity bigmux is
	port 
	(
		A, B : in std_logic_vector(15 downto 0);
		s : in std_logic;
		D : out std_logic_vector (15 downto 0)
	);
end entity;

architecture big of bigmux is
	signal s1 : std_logic_vector(15 downto 0) := (0 => s, others => '0');
begin 
	--st1 : twomux port map (a => A(0), b => B(0), s => s, r => D(0));
	--st2 : twomux port map (a => A(1), b => B(1), s => s, r => D(1));
	--st3 : twomux port map (a => A(2), b => B(2), s => s, r => D(2));
	--st4 : twomux port map (a => A(3), b => B(3), s => s, r => D(3));
	--st5 : twomux port map (a => A(4), b => B(4), s => s, r => D(4));
	--st6 : twomux port map (a => A(5), b => B(5), s => s, r => D(5));
	--st7 : twomux port map (a => A(6), b => B(6), s => s, r => D(6));
	--st8 : twomux port map (a => A(7), b => B(7), s => s, r => D(7));
	--s1 <= s1 + s;
	D <= (A and (not s1)) or (B and s1);
end architecture;