library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RCA is
    port ( A, B : in    STD_LOGIC_VECTOR(7 DOWNTO 0);
           CIN  : in    STD_LOGIC;
           SUM  : out   STD_LOGIC_VECTOR(7 DOWNTO 0);
           COUT : out   STD_LOGIC
         );
end RCA;

architecture structural of RCA is
    component FA
        port (a, b, cin : in    STD_LOGIC;
              sum, cout : out   STD_LOGIC
             );
    end component;

    signal c1, c2, c3, c4, c5, c6, c7   :   STD_LOGIC;

begin
    a0  :   FA port map (A(0), B(0), CIN, SUM(0), c1);
    a1  :   FA port map (A(1), B(1), c1, SUM(1), c2);
    a2  :   FA port map (A(2), B(2), c2, SUM(2), c3);
    a3  :   FA port map (A(3), B(3), c3, SUM(3), c4);
    a4  :   FA port map (A(4), B(4), c4, SUM(4), c5);
    a5  :   FA port map (A(5), B(5), c5, SUM(5), c6);
    a6  :   FA port map (A(6), B(6), c6, SUM(6), c7);
    a7  :   FA port map (A(7), B(7), c7, SUM(7), COUT);
end structural;
