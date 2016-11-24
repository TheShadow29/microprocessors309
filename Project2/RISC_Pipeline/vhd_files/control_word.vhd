library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all_components.all;

-- Will output 0 if nop==1
entity ControlWord is
	port (
		cin: std_logic_vector;
		cout: std_logic_vector;
		nop: std_logic
	);
end entity ControlWord;

architecture Control of ControlWord is
begin
	cout <= cin when nop = '0' else
			  (others => '0');
end Control;