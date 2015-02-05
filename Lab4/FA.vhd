library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FA is 
    port ( a, b, cin    : in    STD_LOGIC;
           sum, cout    : out   STD_LOGIC
         );
end FA;

architecture dataflow of FA is
begin
    sum  <=  a xor b xor cin;
    cout <=  (a and b) or (a and cin) or (b and cin);
end dataflow;
