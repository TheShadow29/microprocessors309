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
		Rsrc, Rmem, Rwb : in std_logic_vector(2 downto 0);
		NOPmem, NOPwb, LW : in std_logic;
		Idef, Imem, Iwb, Ipc : in std_logic_vector(15 downto 0);
		Wen_mem, Wen_wb : in std_logic;
		Fout : out std_logic_vector(15 downto 0);
		Stall : out std_logic
	);
end entity;

architecture Selector of ForwardingUnit is
	signal out_select : std_logic_vector(1 downto 0);
	constant seven_3b : std_logic_vector(2 downto 0) := (others => '1');
begin

	process(Rsrc,Rmem,Rwb,NOPmem,NOPwb,LW, Wen_mem,Wen_wb) is
		variable out_select_var : std_logic_vector(1 downto 0);
		variable stall_var : std_logic;
	begin
		stall_var := '0';
		--00 : alui1
		--01 : ADmem
		--10 : Dwb
		--11 : PC
		out_select_var := "00"; --chose alui1 as the default
		if(Rsrc = seven_3b) then
			out_select_var := "11"; --if R7 then need to use the current pc
		else
			if (NOPmem = '0' and Rsrc = Rmem and Wen_mem = '1') then
				if (LW = '1') then
					stall_var := '1';
				else
					out_select_var := "01"; -- if it is not LW we can directly use output of ALU
				end if;
			elsif (NOPwb = '0' and Rsrc = Rwb and Wen_wb = '1') then
				out_select_var := "10";  -----------NOT SURE --------------
			end if;
		end if;
		
		out_select <= out_select_var;
		Stall <= stall_var;
	end process;

	Fout <= Ipc when out_select = "11" else 
	        Imem when out_select = "01" else
			  Iwb  when out_select = "10" else
			  Idef;
end architecture Selector;

library ieee;
use ieee.std_logic_1164.all;

entity forwarding_unit_jlr is
	port (
		Rsrc, Rmem, Rwb, Rexec : in std_logic_vector(2 downto 0);
		NOPmem, NOPwb, NOPexec, LWmem, LWexec,JLR: in std_logic;
		Wen_exec, Wen_mem, Wen_wb : in std_logic;
		Idef, Ialu_out, Imem_out, Ipc : in std_logic_vector(15 downto 0);
		Fout : out std_logic_vector(15 downto 0);
		Freeze : out std_logic
	);
end entity;

architecture Selector of forwarding_unit_jlr is
	signal out_select : std_logic_vector(1 downto 0);
	constant seven_3b : std_logic_vector(2 downto 0) := (others => '1');
begin

	process(Rsrc,Rmem,Rwb,Rexec,NOPexec,NOPmem,NOPwb,LWmem, LWexec,Wen_exec,Wen_mem,Wen_wb,JLR) is
		variable out_select_var : std_logic_vector(1 downto 0);
		variable freeze_var : std_logic;
	begin
		--00 : D1
		--01 : ALUout
		--10 : Dout_mem
		--11 : current PC
		freeze_var := '0';
		out_select_var := "00";	 --choosing D1 by default
		if(JLR = '1') then
			if(Rsrc = seven_3b) then --if Rsrc == R7 then we need to take from current PC
				out_select_var := "11"; -- choose current PC
			else
				if (NOPexec = '0' and Rsrc  = Rexec and Wen_exec = '1') then
					if (LWexec = '1') then
						freeze_var := '1';
					end if;
					out_select_var := "01"; -- if it is not LW in exec stage then we can directly 
												--use the output of the alu else need to wait for another cycle
				elsif (NOPmem = '0' and Rsrc = Rmem and Wen_mem = '1') then
					if (LWmem = '1') then
						out_select_var:= "10"; --if LW in mem stage can directly take output of data ram
					end if;
--				elsif (NOPwb = '0' and Rsrc = Rwb and Wen_wb = '1') then
--					out_select_var := "11"; --the output is all ready correct value already from register file
				end if;
			end if;
		end if;
		
		out_select <= out_select_var;
		Freeze <= freeze_var;
	end process;

	Fout <= Ipc when out_select = "11" else 
	        Ialu_out when out_select = "01" else
			  Imem_out  when out_select = "10" else
			  Idef;
end architecture Selector;