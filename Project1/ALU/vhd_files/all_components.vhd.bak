library ieee;
use ieee.std_logic_1164.all;

package all_components is

	component bigmux is
		port 
		(
			A, B : in std_logic_vector(15 downto 0);
			s : in std_logic;
			D : out std_logic_vector (15 downto 0)
		);
	end component;
	
	component alu is
		port
		(
			X, Y : in std_logic_vector(15 downto 0);
			Z : out std_logic_vector(15 downto 0);
			op_code : in std_logic
		);
	end component;

end all_components;