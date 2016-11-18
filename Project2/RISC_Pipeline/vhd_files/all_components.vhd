library ieee;
use ieee.std_logic_1164.all;

package all_components is
	component ForwardingUnit is
		port (
			Rsrc, Rmem, Rwb : in std_logic_vector(3 downto 0);
			NOPmem, NOPwb, LW : in std_logic;
			Idef, Imem, Iwb, Ipc : in std_logic_vector(15 downto 0);
			Fout : out std_logic_vector(15 downto 0);
			Stall : out std_logic
		);
	end ForwardingUnit;
	
	component FlagForwardingUnit is
		port (
			Flag : in std_logic_vector(1 downto 0);
			Cmem, Zmem, NOPmem : in std_logic;
			
			ForwardOut : out std_logic
		);
	end FlagForwardingUnit;
end all_components;