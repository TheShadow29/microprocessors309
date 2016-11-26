library ieee;
use ieee.std_logic_1164.all;

library work;
	use work.all_components.all;

entity DataRegister is
	--n bit register
	port (Din: in std_logic_vector;
			Dout: out std_logic_vector;
			clk, enable: in std_logic);
end entity;

architecture NBits of DataRegister is
signal prevDin: std_logic_vector(Din'range) := (others=>'0');
begin

	process(clk)
		variable dout_var : std_logic_vector(Din'range);
	begin
		dout_var := prevDin;
		if(clk'event and (clk = '0')) then
			if enable = '1' then
				--prevDin <= Din;
				dout_var := Din;
			end if;
			prevDin <= dout_var;
		end if;
	end process;
	Dout<=prevDin;
end NBits;

library ieee;
use ieee.std_logic_1164.all;

library work;
	use work.all_components.all;

entity PipelineDataRegister is
	--n bit register
	port (Din: in std_logic_vector;
			Dout: out std_logic_vector;
			clk, enable: in std_logic);
end entity;

architecture NBits of PipelineDataRegister is
signal prevDin: std_logic_vector(Din'range) := (0=>'1', others=>'0');
begin
	process(clk)
		variable dout_var : std_logic_vector(Din'range);
	begin
		dout_var := prevDin;
		if(clk'event and (clk = '0')) then
			if enable = '1' then
				--prevDin <= Din;
				dout_var := Din;
			end if;
			prevDin <= dout_var;
		end if;
	end process;
	Dout<=prevDin;
end NBits;