LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY dfliflop IS
    PORT ( D              : in  STD_LOGIC_VECTOR(N DOWNTO 0); 
           aResetN, Clock : in  STD_LOGIC;
           Q
       );                 : out STD_LOGIC_VECTOR(N DOWNTO 0);
END dflipflop;

ARCHITECTURE behavioral OF flipflop_ar IS
BEGIN
    PROCESS (
        Resetn
        , Clock )
    BEGIN
        IF Resetn = '0' THEN
            Q <= '0' ;
        ELSIF rising_edge(Clock) THEN
            Q <= D ;
        END IF ;
    END PROCESS ;
END behavioral 
