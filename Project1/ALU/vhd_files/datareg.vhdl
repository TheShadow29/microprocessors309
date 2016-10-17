library ieee;
use ieee.std_logic_1164.all;

library work;
	use work.all_components.all;

entity DataRegister is
	--n bit register
	port (Din: in std_logic_vector(15 downto 0);
			Dout: out std_logic_vector(15 downto 0);
			clk, enable: in std_logic);
end entity;

architecture NBits of DataRegister is
begin
	process(clk)
	begin
		if(clk'event and (clk = '1')) then
			if(enable = '1') then
				Dout <= Din;
			end if;
		end if;
	end process;
end NBits;