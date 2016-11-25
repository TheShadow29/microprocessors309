library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all_components.all;

entity history_block is
	port
	(
		pc_br, pc_br_next : in std_logic_vector(15 downto 0);
		hin : in std_logic;
		pc_in : in std_logic_vector(15 downto 0);
		stall_hist : out std_logic := '0';
		br_en : out std_logic := '0';
		pc_out : out std_logic_vector(15 downto 0) := (others => '0')
	);
end entity;

architecture hist of history_block is
	type hist_block_type is array (0 to 1023) of std_logic_vector(33 downto 0);
	--type of storage:
	--		33 : if the block is filled or not
	--		32 : history bit (0 or 1)
	--		31 downto 16 : pc_curr
	--		15 downto 0 : pc_next
	signal hist_block : hist_block_type;
	attribute hist_lut_init_file : string;
   attribute hist_lut_init_file of hist_block : signal is "../programs/history_lut.mif";
	
	signal empty_idx : integer range 0 to 1023 := 0;
begin
	process(pc_br,hin,pc_in)
		variable match_var : std_logic_vector(33 downto 0);
		variable matched : boolean;
		variable hout_var : std_logic := '0';
		variable stall_hist_var : std_logic := '0';
		variable bren_var : std_logic := '0';
		begin
		   matched := false;
			for i in 0 to 1023 loop
				--case1 : if there was prev a branch instruction
				-- 		and now we know which branch was taken
				match_var := hist_block(i);
				if(match_var(33) = '1') then  -- block filled
					if (pc_br = match_var(31 downto 16)) then -- pc_br == pc_curr
						if(match_var(32) = not(hin)) then
							hout_var := hin;
							stall_hist_var := '1';
							bren_var := not(hin);
							matched := true;
							
							match_var(32) := hin;
							exit;
						end if;
					--case2 : if curr pc is a branch instruction
					--			and we need to decide whether to take the
					--			branch or not
					elsif (pc_in = match_var(31 downto 16)) then
						if (match_var(32) = '1') then -- history bit is 1
							bren_var := '1';
						end if;
					end if;
				else
					empty_idx <= i;
				end if;
				hist_block(i) <= match_var;
			end loop;
			
			if(matched = false) then
				match_var(33) := '1';
				match_var(32) := hin;
				match_var(31 downto 16) := pc_br;
				match_var(15 downto 0) := pc_br_next;
			end if;
			
			hist_block(empty_idx) <= match_var;
		end process;
	
end architecture;

