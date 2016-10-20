library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_model is
  port (
    clk   : in  std_logic;
	 rw : in std_logic;
    enable      : in  std_logic;
    address : in  std_logic_vector;
    datain  : in  std_logic_vector;
    dataout : out std_logic_vector
  );
end entity memory_model;

architecture RTL of memory_model is

   type ram_type is array (0 to 65535) of std_logic_vector(15 downto 0);
   signal ram : ram_type;
   signal read_address : std_logic_vector(address'range);

begin

  RamProc: process(clk) is

  begin
    if rising_edge(clk) then
      if enable = '1' then
        ram(to_integer(unsigned(address))) <= datain;
      end if;
      read_address <= address;
    end if;
  end process RamProc;
  dataout <= ram(to_integer(unsigned(read_address)));

end architecture RTL;