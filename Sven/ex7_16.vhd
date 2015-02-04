library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

ENTITY  ex7_16 IS
    PORT ( reset    :   IN  STD_LOGIC;
           clk      :   IN  STD_LOGIC;
           U_D      :   IN  STD_LOGIC;
           Q        :   OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
         ); 
END ex7_16;

ARCHITECTURE arch_ex7_16 OF ex7_16 IS

    SIGNAL Q_SIGNAL : UNSIGNED (2 DOWNTO 0);

BEGIN
    PROCESS(reset, clk)
    BEGIN
        IF (reset = '1') THEN
            Q_SIGNAL <= "000" --(Q_Signal = (OTHERS => '0')
        ELSIF rising_edge(clk) THEN
            IF (U_D = '0') THEN
                IF (Q_SIGNAL = "111") THEN
                    Q_SIGNAL <= 000;
                ELSE
                    Q_SIGNAL <= Q_SIGNAL+1;
                END IF;
            ELSE
                IF (Q_SIGNAL = "000") THEN
                    Q_SIGNAL <= "111";
                ELSE
                    QSIGNAL <= Q_SIGNAL-1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    Q <= STD_LOGIC_VECTOR(Q_SIGNAL);
END arch_ex7_16;
