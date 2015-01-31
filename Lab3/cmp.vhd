library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity cmp is
    port ( A, B     :   in  STD_LOGIC_VECTOR(7 DOWNTO 0);
           EQ, NEQ  :   out STD_LOGIC
         );
end cmp;

architecture dataflow of cmp is
    signal tmp : STD_LOGIC;

begin
--  tmp <= (A(0) xor B(0)) or (A(1) xor B(1)) or (A(2) xor B(2)) or 
--          (A(3) xor B(3)) or (A(4) xor B(4)) or (A(5) xor B(5)) or
--          (A(6) xor B(6)) or (A(7) xor B(7));
    GEN: for I in 0 to 7 generate
        tmp <= (A(I) xor B(I)) or tmp;
    end generate GEN;

    EQ  <= tmp;
    NEQ <= not tmp;
end dataflow;



