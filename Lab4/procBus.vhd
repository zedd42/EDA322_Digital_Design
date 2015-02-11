LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY procBus IS
    Port    (   INSTRUCTION     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
                DATA            : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
                ACC             : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
                EXTDATA         : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
                OUTPUT          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
                instrSEL        : IN  STD_LOGIC;
                dataSEL         : IN  STD_LOGIC;
                accSEL          : IN  STD_LOGIC;
                extdataSEL      : IN  STD_LOGIC;
                ERR             : OUT STD_LOGIC
            );
END procBus;

ARCHITECTURE arch OF procBus IS
    SIGNAL sel        :  STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN
    sel(0) <= instrSEL OR dataSEL;
    sel(1) <= instrSEL OR accSEL;

    ERR <= (instrSEL AND dataSEL) OR (instrSEL AND accSEL) OR (instrSEL AND extdataSEL) OR 
           (dataSEL AND accSEL) OR (dataSEL AND extdataSEL) OR (accSEL AND extdataSEL);

    WITH sel SELECT
        OUTPUT <= INSTRUCTION   when "11",
                  DATA          when "01",
                  ACC           when "10",
                  EXTDATA       when OTHERS;
end arch;