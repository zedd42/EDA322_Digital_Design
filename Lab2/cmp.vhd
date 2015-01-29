library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity cmp is
    port ( A, B     :   in  STD_LOGIC_VECTOR(7 DOWNTO 0);
           EQ, NEQ  :   out STD_LOGIC
         );
end cmp;

architecture dataflow of cmp is
begin
    EQ  <=  '1' when A = B else '0';
    NEQ <=  '1' when A > B else '0';
    NEQ <=  '1' when A < B else '0';
end dataflow;
