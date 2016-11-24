library ieee ;
use ieee.std_logic_1164.all ;
library work;
use work.all_components.all;

entity PriorityEncoder is
	port ( x : in std_logic_vector(7 downto 0) ;
			 S : out std_logic_vector(2 downto 0);
			 N : out std_logic;
			 Tn: out std_logic_vector(7 downto 0)
		) ;
end PriorityEncoder ;
architecture comb of PriorityEncoder is
signal stmp : std_logic_vector(2 downto 0);
signal fbit : std_logic_vector(7 downto 0);
begin
	N <= ( x(7) or x(6) or x(5) or x(4) or x(3) or x(2) or x(1) or x(0) ) ;
	 pri_enc : process (x) is
    begin
        if (x(7)='1') then
            stmp <= "111";
        elsif (x(6)='1') then
            stmp <= "110";
        elsif (x(5)='1') then
            stmp <= "101";
        elsif (x(4)='1') then
            stmp <= "100";
        elsif (x(3)='1') then
            stmp <= "011";
        elsif (x(2)='1') then
            stmp <= "010";
        elsif (x(1)='1') then
            stmp <= "001";
        elsif (x(0)='1') then
            stmp <= "000";
			else
				stmp <= "000";
        end if;
    end process pri_enc;
	 
	 s <= stmp;
	 decoder1: Decoder8 port map (A=>stmp,O=>fbit,OE=>'1');
	 Tn <= not(fbit) and x;
end comb ;