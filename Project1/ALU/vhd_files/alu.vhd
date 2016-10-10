library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.std_logic_unsigned.ALL;
	use ieee.numeric_std.all ;

library work;
	use work.all_components.all;

--alu will implement add and nand functions depending on the opcode

entity alu is
	port
	(
		X, Y : in std_logic_vector(15 downto 0);
		Z : out std_logic_vector(15 downto 0);
		op_code : in std_logic
	);
end alu;

architecture implementation of alu is 
	signal lsb , msb : std_logic;
	signal tmp1, tmp2 : std_logic_vector(15 downto 0);
begin 
	--lsb <= op_code(0);
	--msb <= op_code(1);
	--ad_sub : EightBitAdd port map (A => X, B => Y, sel => lsb, Z => tmp1);
	--lef_rig : shifter port map (A => X, B => Y, left => lsb, Z => tmp2);

	tmp1 <= X + Y;
	tmp2 <= not(X and Y);

	final: bigmux port map (A => tmp1, B => tmp2 , s => op_code , D => Z);

end architecture;