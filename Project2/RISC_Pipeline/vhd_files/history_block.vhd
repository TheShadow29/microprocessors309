library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all_components.all;

entity history_block is
	port
	(
		pc_br, pc_br_next : in std_logic_vector(15 downto 0);
		hin, clk,BEQ : in std_logic;
		pc_in : in std_logic_vector(15 downto 0);
		stall_hist : out std_logic := '0';
		br_en : out std_logic := '0';
		pc_out : out std_logic_vector(15 downto 0) := (others => '0')
	);
end entity;

architecture hist of history_block is
	--type of storage:
	--		34 : mru -> 1 if most recently used
	--		33 : if the block is filled or not
	--		32 : history bit (0 or 1)
	--		31 downto 16 : pc_curr
	--		15 downto 0 : pc_next
	type hist_block_type is array (0 to 31) of std_logic_vector(34 downto 0);
	signal hist_block : hist_block_type;
--	attribute hist_lut_init_file : string;
--   attribute hist_lut_init_file of hist_block : signal is "../programs/history_lut.mif";
	
	--signal empty_idx : integer range 0 to 1023 := 0;
	signal pc_out_hin0, pc_out_hin1 : std_logic_vector(15 downto 0);
begin
		Hin0 : Incrementer port map (x => pc_br, z => pc_out_hin0);
	process(clk,pc_br,hin,pc_in)
		variable match_var : std_logic_vector(34 downto 0);
		variable matched, empty_found : boolean;
		variable hout_var : std_logic := '0';
		variable stall_hist_var : std_logic := '0';
		variable bren_var : std_logic := '0';
		variable pc_out_var : std_logic_vector(15 downto 0);
		variable empty_idx_var : integer range 0 to 1023 := 0;
		begin
		   matched := false;
			empty_found := false;
			bren_var := '0';
			match_var := hist_block(0);
			stall_hist_var := '0';
			pc_out_var := match_var(15 downto 0);
			--empty_idx_var := 0;
			for i in 0 to 31 loop
				--case1 : if there was prev a branch instruction
				-- 		and now we know which branch was taken
				match_var := hist_block(i);
				if(match_var(33) = '1') then  -- block filled
					if (pc_br = match_var(31 downto 16) and BEQ = '1') then -- pc_br == pc_curr
						match_var(34) := '1'; -- Used
						if(match_var(32) = not(hin)) then	--Hout != Hin
							
							stall_hist_var := '1';	--Need to stall 
							bren_var := '1';	--Need to use the new PC
							matched := true;	--There was a matching PC
							
							match_var(32) := hin;	--Update the Hout in the table
							if (hin = '1') then --use pc_br_next
								pc_out_var := match_var(15 downto 0);	--if Hin=1 then use pc_br_next
							else
								pc_out_var := pc_out_hin0;		---else use PC + 1
							end if;
							exit;
						end if;
					--case2 : if curr pc is a branch instruction
					--			and we need to decide whether to take the
					--			branch or not
					elsif (pc_in = match_var(31 downto 16)) then
						match_var(34) := '1';
						if (match_var(32) = '1') then -- history bit is 1
							bren_var := '1';
							pc_out_var := match_var(15 downto 0);
						end if;
					else
						match_var(34) := '0'; -- Not matched so not used
						if(not(empty_found)) then
							empty_idx_var := i;
						end if;
					end if;
					hist_block(i) <= match_var;
				else
					empty_idx_var := i;
					empty_found := true;
					exit;
				end if;
				
			end loop;
			
			if(matched = false and BEQ = '1') then
				match_var(34) := '1';
				match_var(33) := '1';
				match_var(32) := hin;
				match_var(31 downto 16) := pc_br;
				match_var(15 downto 0) := pc_br_next;
				
				if (hin = '1') then
					bren_var := '1';
					pc_out_var := pc_br_next;
					stall_hist_var := '1';
				end if;
			end if;
			
			if(clk'event and clk = '0') then 
				hist_block(empty_idx_var) <= match_var;
			end if;
			pc_out <= pc_out_var;
			br_en <= bren_var;
			stall_hist <= stall_hist_var;
			--empty_idx <= empty_idx_var;
		end process;
end architecture;

