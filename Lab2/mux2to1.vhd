library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1 is
    Port ( a, b      : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           s         : in STD_LOGIC;
           z         : out STD_LOGIC_VECTOR(7 DOWNTO 0)
         );
end mux2to1;

architecture structure of mux2to1 is
    component and8 is 
        Port ( a, b : in STD_LOGIC_VECTOR(7 DOWNTO 0);
               f    : out STD_LOGIC_VECTOR(7 DOWNTO 0)
             );
    end component and8;

    component or8 is
        Port ( a, b : in STD_LOGIC_VECTOR(7 DOWNTO 0);
               f    : out STD_LOGIC_VECTOR(7 DOWNTO 0)
             );
    end component or8;

    component not8 is
        Port ( a    : in STD_LOGIC_VECTOR(7 DOWNTO 0);
               f    : out STD_LOGIC_VECTOR(7 DOWNTO 0)
             );
    end component not8;

    signal m, n, o, sel  : STD_LOGIC_VECTOR(7 DOWNTO 0);


begin
        sel <= "00000000" when s='0' else "11111111";
        o0  :   and8    port map (a,   m, n);
        o1  :   and8    port map (sel, b, o);
        o2  :   or8     port map (n,   o, z);
        o3  :   not8    port map (sel, m);

end structure;
