library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity notg is
    Port ( a    : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           z    : out STD_LOGIC_VECTOR(7 DOWNTO 0)
         );
 end notg;

architecture structure of notg is
begin
    z <= not a;
end structure;
