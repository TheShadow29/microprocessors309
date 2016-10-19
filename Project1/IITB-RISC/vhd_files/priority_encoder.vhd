library ieee ;
use ieee.std_logic_1164.all ;
entity PriorityEncoder is
	port ( x : in std_logic_vector(7 downto 0) ;
		S : out std_logic_vector(2 downto 0);
	 N : out std_logic ) ;
end PriorityEncoder ;
architecture comb of PriorityEncoder is
begin
	N <= ( x(7) or x(6) or x(5) or x(4) or x(3) or x(2) or x(1) or x(0) ) ;
	 pri_enc : process (x) is
    begin
        if (x(7)='1') then
            s <= "111";
        elsif (x(6)='1') then
            s <= "110";
        elsif (x(5)='1') then
            s <= "101";
        elsif (x(4)='1') then
            s <= "100";
        elsif (x(3)='1') then
            s <= "011";
        elsif (x(2)='1') then
            s <= "010";
        elsif (x(1)='1') then
            s <= "001";
        elsif (x(0)='1') then
            s <= "000";
			else
				s<= "000";
        end if;
    end process pri_enc;
--	s(0) <= ( x(1) and not x(0) ) or
--		( x(3) and not x(2) and not x(1) and not x(0) ) or
--		( x(5) and not x(4) and not x(3) and not x(2) and
--			not x(1) and not x(0) ) or
--		( x(7) and not x(6) and not x(5) and not x(4)
--			and not x(3) and not x(2) and not x(1)
--			and not x(0) ) ;
--	s(1) <= ( x(2) and not x(1) and not x(0) ) or
--		( x(3) and not x(2) and not x(1) and not x(0) ) or
--		( x(6) and not x(5) and not x(4) and not x(3) and
--			not x(2) and not x(1) and not x(0) ) or
--		( x(7) and not x(6) and not x(5) and not x(4) and
--			not x(3) and not x(2) and not x(1) and not x(0) ) ;
--	s(2) <= ( x(4) and not x(3) and not x(2) and
--			not x(1) and not x(0) ) or
--		( x(5) and not x(4) and not x(3) and not x(2) and
--			not x(1) and not x(0) ) or
--		( x(6) and not x(5) and not x(4) and not x(3)
--			and not x(2) and not x(1) and not x(0) ) or
--		( x(7) and not x(6) and not x(5) and not x(4) and not x(3)
--			and not x(2) and not x(1) and not x(0) ) ;
end comb ;