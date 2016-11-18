library ieee;
use ieee.std_logic_1164.all;

-- Rsrc : Address of source register
-- Rmem, Rwb : Address of destination registers in Mem and WB stage
-- NOPmem, NOPwb : NOP bits of Mem and WB stage
-- Idef : Default output after forwarding, i.e. the current data we have
-- Imem, Iwb, Ipc : Data inputs from Mem stage, WB stage and PC of current stage.

-- Fout : The data output after forwarding
-- Stall : Whether we need to stall for LW or not 
entity ForwardingUnit is
	port (
		Rsrc, Rmem, Rwb : in std_logic_vector(3 downto 0);
		NOPmem, NOPwb, LW : in std_logic;
		Idef, Imem, Iwb, Ipc : in std_logic_vector(15 downto 0);
		Fout : out std_logic_vector(15 downto 0);
		Stall : out std_logic
	);
end entity;

architecture Selector of ForwardingUnit is
	signal out_select : std_logic_vector(1 downto 0);
begin

	process(Rsrc,Rmem,Rwb,NOPmem,NOPwb,LW) is
		variable out_var : std_logic_vector(1 downto 0);
		variable stall_var : std_logic;
	begin
		stall_var := 0;
		
		if(Rsrc = "111") then
			out_var := "11";
		else
			if(LW = '1') then
				stall_var := '1';
			elsif(NOPmem = '1' and Rsrc = Rmem) then
				out_var := "10";
			elsif(NOPwb = '1' and Rsrc = Rwb) then
				out_var := "01";
			else
				out_var := "00";
			end if;
		end if;
		
		out_select <= out_var;
		Stall <= stall_var;
	end process;

	Fout <= Idef when out_select = "11" else 
	        Imem when out_select = "10" else
			  Iwb  when out_select = "01" else
			  Idef;
end architecture Selector;