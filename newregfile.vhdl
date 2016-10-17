library ieee;
use ieee.std_logic_1164.all;
library work;
use work.SMC_Components.all;
entity RegFile is
port(
 D1,D2: out std_logic_vector(15 downto 0);
 A1,A2,A3 :in std_logic_vector(2 downto 0);
 D3 :in std_logic_vector(15 downto 0);
 );
end entity RegFile;
architecture Behave of RegFile is
 type RegArray is array (natural range <>) of std_logic_vector(15 downto 0);
 --SIGNAL regA : std_logic_vector(7 downto 0) := (others => DataRegisterNew);
 type EnableArray is array (natural range <>) of std_logic;

 
 signal R: RegArray(7 downto 0);
 signal En: EnableArray(7 downto 0);
begin

RegFile:
for I in 0 to 7 generate
	RegFileX: DataRegisterNew(Dout=>R[I],Enable=>En[I],Din=>D3,clk=>clk);
end generate RegFile;



 end Behave;
---------------------------