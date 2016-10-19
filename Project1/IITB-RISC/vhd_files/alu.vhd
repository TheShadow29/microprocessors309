library ieee ;
	use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all;
library work;
	use work.all_components.all;

--alu will implement add and nand functions depending on the opcode

entity alu is
	port
	(
		X, Y : in std_logic_vector(15 downto 0);
		out_p : out std_logic_vector(15 downto 0);
		C, Z : out std_logic;
		op_code : in std_logic 
	);
end alu;

architecture implementation of alu is 
	signal lsb , msb : std_logic;
	signal x16, y16: std_logic_vector(16 downto 0) := (others => '0');
	signal tmp1, tmp2, sigout : std_logic_vector(15 downto 0);
	
begin 
	--lsb <= op_code(0);
	--msb <= op_code(1);
	--ad_sub : EightBitAdd port map (A => X, B => Y, sel => lsb, Z => tmp1);
	--lef_rig : shifter port map (A => X, B => Y, left => lsb, Z => tmp2);
	x16(15 downto 0) <= X;
	y16(15 downto 0) <= Y;
	
	adder1: Adder port map(x=>X,y=>Y,z=>tmp1,cin=>'0',cout=>C);
	tmp2 <= not(X and Y);
	
	Z <= sigout(0) or
			sigout(1) or
			sigout(2) or
			sigout(3) or
			sigout(4) or
			sigout(5) or
			sigout(6) or
			sigout(7) or
			sigout(8) or
			sigout(9) or
			sigout(10) or
			sigout(11) or
			sigout(12) or
			sigout(13) or
			sigout(14) or
			sigout(15);
			
	out_p <= sigout;
	
	final: mux2 port map (A0 => tmp1, A1 => tmp2 , s => op_code , D => sigout);

end architecture;
