library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity org is
    Port ( a, b : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           z    : out STD_LOGIC_VECTOR(7 DOWNTO 0)
         );
 end org;

architecture structure of org is
begin
    z <= a or b;
end structure;
