library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity andg is
    Port ( a, b : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           z    : out STD_LOGIC_VECTOR(7 DOWNTO 0)
         );
 end andg;

architecture structure of andg is
begin
    z <= a and b;
end structure;
