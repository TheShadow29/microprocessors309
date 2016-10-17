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
			out_p : out std_logic_vector(15 downto 0);
			C, Z : out std_logic;
			op_code : in std_logic 
		);
	end component;
	
	component DataRegister is
		--n bit register
		port (Din: in std_logic_vector(15 downto 0);
				Dout: out std_logic_vector(15 downto 0);
				clk, enable: in std_logic);
	end component;
	
	component RegFile is
		port(
			D1,D2: out std_logic_vector(15 downto 0);
			A1,A2,A3 :in std_logic_vector(2 downto 0);
			D3 :in std_logic_vector(15 downto 0);
			clk: in std_logic
		 );
	end component RegFile;

end all_components;