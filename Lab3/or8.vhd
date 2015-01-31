library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity or8 is
    Port ( a, b : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           f    : out STD_LOGIC_VECTOR(7 DOWNTO 0)
         );
 end or8;

architecture dataflow of or8 is
begin
    f <= a or b;
end dataflow;
