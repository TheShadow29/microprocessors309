library ieee;
use ieee.std_logic_1164.all;

package all_components is

	component mux2 is
		port 
		(
			A0,A1 : in std_logic_vector(15 downto 0);
			s : in std_logic;
			D : out std_logic_vector (15 downto 0)
		);
	end component;
	
	component mux4 is
		port 
		(
			A0,A1,A2,A3 : in std_logic_vector(15 downto 0);
			s : in std_logic_vector(1 downto 0);
			D : out std_logic_vector (15 downto 0)
		);
	end component;
	
	component mux8 is
		port 
		(
			A0,A1,A2,A3,A4,A5,A6,A7 : in std_logic_vector(15 downto 0);
			s : in std_logic_vector(2 downto 0);
			D : out std_logic_vector (15 downto 0)
		);
	end component;
	
	component Adder is
		 port(
			  cin: in std_logic;
			  x, y: in std_logic_vector(15 downto 0);
			  z: out std_logic_vector(15 downto 0);
			  cout: out std_logic
		 );
	end component;
	
	component Decoder8 is
		port (
			A: in std_logic_vector(2 downto 0);
			OE: in std_logic;
			O: out std_logic_vector(7 downto 0)
		);
	end component Decoder8;
	
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
			clk, WR: in std_logic
		 );
	end component RegFile;
	
	component iitb_risc is
		port (
			alui1, alui2: in std_logic_vector(15 downto 0);
			aluo: out std_logic_vector(15 downto 0);
			aluc: in std_logic;
			C,Z: out std_logic;
			
			D1,D2: out std_logic_vector(15 downto 0);
			D3: in std_logic_vector(15 downto 0);
			A1,A2,A3: in std_logic_vector(2 downto 0);
			
			clk, WR: in std_logic
		);
	end component iitb_risc;

end all_components;