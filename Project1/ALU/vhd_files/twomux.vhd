library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

library work;
	use work.all_components.all;

entity twomux is
	port
	(
		a, b, s : in std_logic;
		r : out std_logic
	);
end entity;

architecture mux of twomux is
begin
	r <= (a and (not s)) or (b and s);
end architecture;