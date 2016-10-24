library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_model is
  port (
    clk   : in  std_logic;
	 rw : in std_logic;
    address : in  std_logic_vector;
    data  : inout  std_logic_vector
  );
end entity memory_model;

architecture RTL of memory_model is

   type ram_type is array (0 to 65535) of std_logic_vector(15 downto 0);
   signal ram : ram_type;
	signal read_signal : std_logic_vector(15 downto 0);
	
	constant highZ : std_logic_vector(data'range) := (others => 'Z');
begin
  RamProc: process(clk,address,data,rw) is

  begin
    if rising_edge(clk) then
      if rw = '1' then
		  -- Write
		  data <= highZ;
        ram(to_integer(unsigned(address))) <= data;
		else
			read_signal <= ram(to_integer(unsigned(address)));
      end if;
		
	end if;
	 
  end process RamProc;
  
  data <= read_signal when rw ='0'
          else highZ;

end architecture RTL;