library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1 is
    Port ( a, b      : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           sel       : in STD_LOGIC;
           z         : out STD_LOGIC_VECTOR(7 DOWNTO 0)
         );
end mux2to1;

architecture structure for mux2to1 is
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

    signal m, n, o  : STD_LOGIC_VECTOR(7 DOWNTO 0);

begin
        u0  :   and8    port map (a,   m, n);
        u1  :   and8    port map (sel, b, o);
        u2  :   or8     port map (n,   o, z);
        u3  :   not8    port map (sel, m);

end mux2to1;
