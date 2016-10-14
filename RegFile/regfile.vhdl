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
 
 signal Dtest: std_logic_vector(15 downto 0);
begin
reg1: DataRegisterNew
port map (Din => D3,
 Dout => Dtest,
 Enable => '1',
 clk => clk);
 
 
 reg2: DataRegisterNew
port map (Din => D3,
 Dout => Dtest,
 Enable => '1',
 clk => clk);
 
 
reg3: DataRegisterNew
port map (Din => D3,
 Dout => Dtest,
 Enable => '1',
 clk => clk);
 
 
reg4: DataRegisterNew
port map (Din => D3,
 Dout => Dtest,
 Enable => '1',
 clk => clk);
 
 
reg5: DataRegisterNew
port map (Din => D3,
 Dout => Dtest,
 Enable => '1',
 clk => clk);
 
 
reg6: DataRegisterNew
port map (Din => D3,
 Dout => Dtest,
 Enable => '1',
 clk => clk);
 
 
reg7: DataRegisterNew
port map (Din => D3,
 Dout => Dtest,
 Enable => '1',
 clk => clk);
 
 
reg8: DataRegisterNew
port map (Din => D3,
 Dout => Dtest,
 Enable => '1',
 clk => clk);


 end Behave;
---------------------------