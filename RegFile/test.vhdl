library std;
library ieee;
use ieee.std_logic_1164.all;
package SMC_Components is
component SMC_DataPath is
port
 (
T0,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11: in std_logic;
S,S2: out std_logic;
SRAM_data : inout std_logic_vector(7 downto 0);
 SRAM_address: in std_logic_vector(12 downto 0);
inputaddressofSRAM: out std_logic_vector(12 downto 0);
 SRAM_write_data : in std_logic_vector(7 downto 0);
 SRAM_read_data: out std_logic_vector(7 downto 0);
 notCS,notWR,notOE: out std_logic;
clk, reset: in std_logic
 );
end component SMC_DataPath;
component SMC_ControlPath is
port
 (
 T0,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11: out std_logic;
 SRAM_start,SRAM_write:in std_logic;
 S,S2: in std_logic;
 SRAM_done: out std_logic;
 clk, reset: in std_logic);
end component SMC_ControlPath;
component SMC is
 port
(SRAM_start,SRAM_write:in std_logic;
 SRAM_address: in std_logic_vector(12 downto 0);
 inputaddressofSRAM: out std_logic_vector(12 downto 0);
 SRAM_write_data: in std_logic_vector(7 downto 0);
 SRAM_data : inout std_logic_vector(7 downto 0);
 SRAM_read_data: out std_logic_vector(7 downto 0);
 notCS,notWR,notOE: out std_logic;
Final project - EE214
Shrey Gadiya-14D070006
Jagesh Golwala-14D070005
 SRAM_done: out std_logic;
 clk, reset: in std_logic
 );
end component SMC;
--n bit register
component DataRegister is
generic (data_width:integer);
port (Din: in std_logic_vector(data_width-1 downto 0);
 Dout: out std_logic_vector(data_width-1 downto 0);
 clk, enable: in std_logic);
end component DataRegister;
---one bit register
component DataRegisterNew is
port (Din: in std_logic;
 Dout: out std_logic;
 clk, enable: in std_logic);
end component DataRegisterNew;
end package;