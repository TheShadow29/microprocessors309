library ieee;
	use ieee.std_logic_1164.all;
library work;
	use work.all_components.all;

entity FullAdder is
    -- x, y -> input bits
    -- ci   -> carry in
    -- s    -> sum
    -- co   -> carry out
    port(
        x, y, ci: in std_logic;
        s, co: out std_logic
    );
end entity;
architecture Behave of FullAdder is
    signal w, z: std_logic;
begin
    -- w <= x xor y
    w <= ((not x) and y) or (x and (not y));
    -- s <= w xor ci
    s <= ((not w) and ci) or (w and (not ci));
    co <= (x and y) or ((x or y) and ci);
end Behave;

library ieee;
	use ieee.std_logic_1164.all;
library work;
	use work.all_components.all;

entity Adder is
    -- cin    -> carry in
    -- x, y   -> 8 bit inputs
    -- z      -> sum output
    -- cout   -> carry out
    port(
        cin: in std_logic;
        x, y: in std_logic_vector(15 downto 0);
        z: out std_logic_vector(15 downto 0);
        cout: out std_logic
    );
end entity;
architecture Behave of Adder is
    -- c(i) holds carry in of i'th FullAdder, i.e. carry generated by (i-1)'th FullAdder
    signal c: std_logic_vector(16 downto 0);

    component FullAdder is
        port(
            x, y, ci: in std_logic;
            s, co: out std_logic
        );
    end component;
begin
    c(0) <= cin;
    fadders:
	 for i in 0 to 15 generate
			adx: FullAdder port map(x=>x(i), y=>y(i), ci=>c(i), co=>c(i+1));
	 end generate fadders;
	 cout <= c(16);
end Behave;

library ieee;
	use ieee.std_logic_1164.all;
library work;
	use work.all_components.all;

entity Incrementer is
    port(
        x: in std_logic_vector(15 downto 0);
        z: out std_logic_vector(15 downto 0)
    );
end entity;
architecture Behave of Incrementer is
    -- z=x+1
begin
    add_1 : Adder port map (x => x, y => (others => '0'), z => z, cin => '1');
end Behave;