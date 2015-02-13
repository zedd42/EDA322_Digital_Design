library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4to1 is
    Port ( a, b, c, d   :   in  STD_LOGIC_VECTOR(7 DOWNTO 0);
           sel          :   in  STD_LOGIC_VECTOR(1 DOWNTO 0);
           z            :   out STD_LOGIC_VECTOR(7 DOWNTO 0)
         );
end mux4to1;

architecture structural of mux4to1 is
    component mux2to1
        Port ( a, b     :   in  STD_LOGIC_VECTOR(7 DOWNTO 0);
               s        :   in  STD_LOGIC;
               z        :   out STD_LOGIC_VECTOR(7 DOWNTO 0)
             );
    end component;

    signal u1, u2   :   STD_LOGIC_VECTOR(7 DOWNTO 0);

begin
    g0  :   mux2to1 port map (a,  b,  sel(0), u1);
    g1  :   mux2to1 port map (c,  d,  sel(0), u2);
    g2  :   mux2to1 port map (u1, u2, sel(1), z);
end structural;
