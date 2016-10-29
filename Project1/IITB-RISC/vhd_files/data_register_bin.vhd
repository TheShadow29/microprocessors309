---data_register_bin.vhd
library ieee;
use ieee.std_logic_1164.all;

library work;
  use work.all_components.all;

entity data_register_bin is
	port (Din: in std_logic;
	      Dout: out std_logic;
	      clk, enable, reset: in std_logic);
end entity;
architecture Behave of data_register_bin is
signal prevDin: std_logic := '0';
begin
	process(clk)
	begin
		if (reset = '1') then
			prevDin <= '0';
			Dout <= '0';
		elsif(clk'event and (clk = '0')) then
			if enable = '1' then
				prevDin <= Din;
				Dout <= Din;
			else
				Dout <= prevDin;
			end if;
		end if;
	end process;
end Behave;
