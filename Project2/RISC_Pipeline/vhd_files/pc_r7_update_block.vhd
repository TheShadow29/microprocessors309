library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all_components.all;

entity pc_r7_update_block is
	port
	(
		nop_bit : in std_logic;
		rd : in std_logic_vector(2 downto 0);
		wen_in : in std_logic;
		wen_out : out std_logic;
		stall : out std_logic;
		r7_upd : out std_logic
	);
end entity;

architecture update of pc_r7_update_block is
begin
	process(nop_bit,wen_in,rd)
		variable stall_var : std_logic;
		variable wen_out_var : std_logic;
		variable r7_upd_var : std_logic;
		begin
			stall_var := '0';
			wen_out_var := '0';
			r7_upd_var := '0';
			if (nop_bit = '0') then
				if (wen_in = '1' and rd = "111") then
					stall_var := '1';
					wen_out_var := '1';
					r7_upd_var := '0';
				else
					r7_upd_var := '1';
				end if;
			end if;
			stall <= stall_var;
			wen_out <= wen_out_var;
			r7_upd <= r7_upd_var;
		end process;
end architecture;