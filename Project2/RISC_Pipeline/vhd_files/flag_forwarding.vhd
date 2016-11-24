library ieee;
use ieee.std_logic_1164.all;

-- Flag : the flag which instruction depends on
-- Cmem,Zmem : Carry and Zero of the instruction in Memory stage
-- NOPmem : Whether the instruction in Memory stage is NOP
-- ForwardOut : output '1' if we want to NOP this operation else '0'.
entity FlagForwardingUnit is
	port (
		Flag : in std_logic_vector(1 downto 0);
		Cmem, Zmem, NOPmem : in std_logic;
		
		ForwardOut : out std_logic
	);
end FlagForwardingUnit;

architecture Selector of FlagForwardingUnit is
begin
	process(Flag, Cmem, Zmem) is
		variable out_var : std_logic;
	begin
		out_var := '0';
		if(Flag = "10" and Cmem = '0') then
			out_var := '1';
		elsif(Flag = "01" and Zmem = '0') then
			out_var := '1';
		end if;
		
		ForwardOut <= out_var;
	end process;
end architecture;