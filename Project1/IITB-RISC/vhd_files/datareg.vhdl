library ieee;
use ieee.std_logic_1164.all;

library work;
	use work.all_components.all;

entity DataRegister is
	--n bit register
	port (Din: in std_logic_vector;
			Dout: out std_logic_vector;
			clk, enable, reset: in std_logic);
end entity;

architecture NBits of DataRegister is
signal prevDin: std_logic_vector(Din'range) := (others=>'0');
begin
	process(clk)
	begin
		if (reset = '1') then
			prevDin <= (others => '0');
			Dout <= (others => '0');
		elsif(clk'event and (clk = '0')) then
			if enable = '1' then
				prevDin <= Din;
				Dout <= Din;
			else
				Dout <= prevDin;
			end if;
		end if;
	end process;
--	Dout<=prevDin;
end NBits;