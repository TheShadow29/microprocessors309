library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all_components.all;

entity history_block is
	port
	(
		pc_br : in std_logic_vector(15 downto 0);
		hin : in std_logic;
		pc_in : in std_logic_vector(15 downto 0);
		stall_hist : out std_logic;
		br_en : out std_logic;
		pc_out : out std_logic
	);
end entity;

architecture hist of history_block is
	type hist_block_type is array (0 to 1023) of std_logic_vector(33 downto 0);
	--type of storage:
	--		33 downto 18 : pc_curr
	--		17 : history bit (0 or 1)
	--		16 : if the block is filled or not
	--		15 downto 0 : pc_next
	signal hist_block : hist_block_type;
begin
	process(pc_br,hin,pc_in)
		variable match_var : std_logic_vector(34 downto 0);
		variable hout_var : std_logic;
		variable stall_hist_var : std_logic;
		variable bren_var : std_logic;
		begin
			for i in 0 to 1023 loop
				--case1 : if there was prev a branch instruction
				-- 		and now we know which branch was taken
				match_var := hist_block(i);
				if (pc_br = match_var(16 downto 1)) then
					if(match_var(0) = not(hin)) then
						hout_var := hin;
						stall_hist_var := '1';
						bren_var := not(hin);
						exit; --to break out from the loop
					end if;
				--case2 : if curr pc is a branch instruction
				--			and we need to decide whether to take the
				--			branch or not
				elsif (pc_in = match_var(16 downto 1)) then
					if (match_var(0) = '1') then
						bren_var := '1';
						
					else
					end if;
				end if;
				
			end loop;
		end process;
	
end architecture;

