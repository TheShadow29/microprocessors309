library ieee;
	use ieee.std_logic_1164.all;
library work;
	use work.all_components.all;
	

entity Decoder8 is
	port (
		A: in std_logic_vector(2 downto 0);
		OE: in std_logic;
		O: out std_logic_vector(7 downto 0)
	);
end entity Decoder8;

architecture Behave of Decoder8 is
begin
O(0) <= not(A(0)) and not(A(1)) and not(A(2)) and OE;
O(1) <= A(0) and not(A(1)) and not(A(2)) and OE;
O(2) <= not(A(0)) and A(1) and not(A(2)) and OE;
O(3) <= A(0) and A(1) and not(A(2)) and OE;
O(4) <= not(A(0)) and not(A(1)) and A(2) and OE;
O(5) <= A(0) and not(A(1)) and A(2) and OE;
O(6) <= not(A(0)) and A(1) and A(2) and OE;
O(7) <= A(0) and A(1) and A(2) and OE;
end architecture;