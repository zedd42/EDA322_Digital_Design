LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY regn IS
    GENERIC( N : INTEGER := 8 );
    PORT( input                     : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          loadEnable, ARESETN, CLK  : IN STD_LOGIC;
          res                       : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0) 
        );
END regn;

ARCHITECTURE behavioral OF regn IS
BEGIN
    PROCESS(ARESETN, CLK)
    BEGIN
        IF ARESETN = '0' THEN
            res <= (OTHERS => '0');
       ELSIF rising_edge(CLK) THEN
           IF loadEnable = '1' THEN
               res <= input;
           END IF;
       END IF;
   END PROCESS;
END behavioral; 
