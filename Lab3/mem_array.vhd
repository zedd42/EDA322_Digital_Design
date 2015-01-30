LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
USE ieee.NUMERIC_STD.all;
USE STD.TEXTIO.all;

ENTITY mem_array is
    GENERIC ( DATA_WIDTH    :   INTEGER := 12;
              ADDR_WIDTH    :   INTEGER := 8;
              INIT_FILE     :   STRING  := "mem_init_func"
          );
    PORT ( ADDR     :   IN  STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
           DATAIN   :   IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
           CLK      :   IN  STD_LOGIC;
           WE       :   IN  STD_LOGIC;
           OUTPUT   :   OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
       );
end mem_array;
ARCHITECTURE arch of mem_array is

    TYPE MEMORY_ARRAY IS ARRAY (ADDR_WIDTH-1 DOWNTO 0) OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    SIGNAL MEM_SIGNAL : MEMORY_ARRAY := init_memory_wfile(INIT_FILE);

BEGIN
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF WE = '1' THEN
                <MEM_SIGNAL>(to_integer(unsigned(ADDR))) := DATAIN;
            ELSE
                OUTPUT <= <MEM_SIGNAL>(to_integer(unsigned(ADDR)));
            END IF;
        END IF;
    END PROCESS;
END arch;
