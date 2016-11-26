library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all_components.all;


entity RISC_Pipeline is
	port
	(
		clk, reset, start : in std_logic;
		done : out std_logic
	);
end entity;

architecture pipe of RISC_Pipeline is
	signal clk_slow : std_logic;
begin
	process(clk)
	begin
		if(clk'event and clk = '0') then 
			clk_slow <= not(clk_slow);
		end if;
	end process;

	dp : data_path port map
			(
				clk => clk_slow,
				reset => reset,
				start => start,
				done => done
			);

end architecture;
