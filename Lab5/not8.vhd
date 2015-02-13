library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity not8 is
    Port ( a    : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           f    : out STD_LOGIC_VECTOR(7 DOWNTO 0)
         );
 end not8;

architecture dataflow of not8 is
begin
    f <= not a;
end dataflow;
