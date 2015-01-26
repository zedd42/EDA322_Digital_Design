library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity and8 is
    Port ( a, b : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           f    : out STD_LOGIC_VECTOR(7 DOWNTO 0)
         );
 end and8;

architecture dataflow of and8 is
begin
    f <= a and b;
end dataflow;
