LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY EDA322_processor IS
    Port ( externalIn         : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
           CLK                : IN  STD_LOGIC;
           master_load_enable : IN  STD_LOGIC;
           ARESETN            : IN  STD_LOGIC;
           pc2seg             : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
           instr2seg          : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
           Addr2seg           : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
           dMemOut2seg        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
           aluOut2seg         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
           acc2seg            : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
           flag2seg           : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
           busOut2seg         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
           disp2seg           : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
           errSig2seg         : OUT STD_LOGIC;
           ovf                : OUT STD_LOGIC;
           zero               : OUT STD_LOGIC
         );
END EDA322_processor;

Declare all components.
Add the respective files to project, if missing.
Portmaps
registers req generic maps

ARCHITECTURE arch OF EDA322_processor IS
    
    COMPONENT alu_wRCA IS
        Port ( ALU_inA, ALU_inB : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
               Operation        : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
               ALU_out          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
               Carry, isOutZero : OUT STD_LOGIC;
               NoEq, Eq         : OUT STD_LOGIC;
    END COMPONENT alu_wRCA;
    
    COMPONENT mem_array IS
        GENERIC ( DATA_WIDTH : INTEGER;
                  ADDR_WIDTH : INTEGER
                ); 
        Port    ( ADDR       : IN  STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
                  DATAIN     : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
                  CLK, WE    : IN  STD_LOGIC;
                  OUTPUT     : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
    END COMPONENT mem_array;
    
    COMPONENT mux2to1 IS
        Port ( A, B : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
               S    : IN  STD_LOGIC;
               Z    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
             );
    END COMPONENT mux2to1;
    
    COMPONENT regn IS
        GENERIC ( N : INTEGER);
        Port    ( Input        : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                  loadEnable   : IN  STD_LOGIC;
                  ARESETN, CLK : IN  STD_LOGIC;
                  res          : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
                );
    END COMPONENT regn;
    

END arch;
