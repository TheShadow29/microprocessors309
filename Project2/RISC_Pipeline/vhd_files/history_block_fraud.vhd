library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all_components.all;

entity history_block_fraud is 
	port
	(
		stall_beq, BEQ : in std_logic;
--		pc_br : in std_logic_vector(15 downto 0);
		pc_br_next : in std_logic_vector(15 downto 0);
		pc_out : out std_logic_vector(15 downto 0);
		br_en, stall_hist : out std_logic
	);
end entity;

architecture check of history_block_fraud is

begin
	process(stall_beq,BEQ)
		variable pc_out_var : std_logic_vector(15 downto 0) := (others => '0');
		variable br_en_var : std_logic := '0';
		variable stall_hist_var : std_logic := '0';
	begin
		pc_out_var := (others => '0');
		br_en_var := '0';
		stall_hist_var := '0';
		if (BEQ = '1') then
			if (stall_beq = '1') then
				br_en_var := '1';
				stall_hist_var := '1';
				pc_out_var := pc_br_next;
			end if;
		end if;
		pc_out <= pc_out_var;
		br_en <= br_en_var;
		stall_hist <= stall_hist_var;
	end process;
end architecture;
