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


ARCHITECTURE arch OF EDA322_processor IS
    
    SIGNAL Instruction, InstrMemOut, zeroVector_12 : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL nxtpc, pc, addFromInstruction, Addr, BusOut, MemDataOut, oneVector_8 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL MemDataOutReged, OutFromAcc, inAcc, PCIncrOut, OUTPUT, aluOut : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL opcode, FlagInp, aluToFlag : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL aluMd : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL neq, eq, pcSel, pcLd, instrLd, addrMd, dmWr, dataLd, flagLd, accSel : STD_LOGIC;
    SIGNAL accLd, im2bus, dmRd, acc2bus, ext2bus, dispLd, zeroLogic, oneLogic : STD_LOGIC;

    COMPONENT procController IS
        Port ( 	master_load_enable : in STD_LOGIC;
				opcode : in  STD_LOGIC_VECTOR (3 downto 0);
				neq : in STD_LOGIC;
				eq : in STD_LOGIC; 
				CLK : in STD_LOGIC;
				ARESETN : in STD_LOGIC;
				pcSel : out  STD_LOGIC;
				pcLd : out  STD_LOGIC;
				instrLd : out  STD_LOGIC;
				addrMd : out  STD_LOGIC;
				dmWr : out  STD_LOGIC;
				dataLd : out  STD_LOGIC;
				flagLd : out  STD_LOGIC;
				accSel : out  STD_LOGIC;
				accLd : out  STD_LOGIC;
				im2bus : out  STD_LOGIC;
				dmRd : out  STD_LOGIC;
				acc2bus : out  STD_LOGIC;
				ext2bus : out  STD_LOGIC;
				dispLd: out STD_LOGIC;
				aluMd : out STD_LOGIC_VECTOR(1 downto 0)
             );
    END COMPONENT procController;

    COMPONENT procBus IS
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
    END COMPONENT procBus;

    COMPONENT alu_wRCA IS
        Port ( ALU_inA, ALU_inB : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
               Operation        : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
               ALU_out          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
               Carry, isOutZero : OUT STD_LOGIC;
               NotEq, Eq         : OUT STD_LOGIC
             );
    END COMPONENT alu_wRCA;
    
    COMPONENT RCA IS
        Port ( A, B : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
               CIN  : IN  STD_LOGIC;
               SUM  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
               COUT : OUT STD_LOGIC
              );
    END COMPONENT RCA;
    
    COMPONENT mem_array IS
        GENERIC ( DATA_WIDTH : INTEGER;
                  ADDR_WIDTH : INTEGER
                ); 
        Port    ( ADDR       : IN  STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
                  DATAIN     : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
                  CLK, WE    : IN  STD_LOGIC;
                  OUTMEM     : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
                );
    END COMPONENT mem_array;
    
    COMPONENT mux2to1 IS
        Port ( A, B : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
               S    : IN  STD_LOGIC;
               Z    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
             );
    END COMPONENT mux2to1;

    COMPONENT mux4to1 IS
        Port ( W, X, Y, Z : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
               Q          : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
               V          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
             );
    END COMPONENT mux4to1;    

    COMPONENT regn IS
        GENERIC ( N : INTEGER := 8);
        Port    ( Input        : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
                  loadEnable   : IN  STD_LOGIC;
                  ARESETN, CLK : IN  STD_LOGIC;
                  res          : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
                );
    END COMPONENT regn;
    
BEGIN
oneLogic <= '1';
zeroLogic <= '0';
oneVector_8 <= "00000001";
zeroVector_12 <= "000000000000";

-- Multiplexorzz
muxPCInc : mux2to1 port map (PCIncrOut, OUTPUT, pcSel, nxtpc);
muxAddr  : mux2to1 port map (Instruction(7 DOWNTO 0), MemDataOutReged, addrMd, Addr);
muxAlu   : mux2to1 port map (aluOut, BusOut, accSel, inAcc);

-- Buzz
procBus1   : procBus port map (addFromInstruction, MemDataOutReged, OutFromAcc, externalIn, BusOut, im2bus, dmRd, acc2bus, ext2bus, errSig2Seg);

-- Registers
fetch : regn generic map (N => 8) port map (nxtpc, pcLd, ARESETN, CLK, pc);
fede  : regn generic map (N => 12) port map (InstrMemOut, instrLd, ARESETN, CLK, Instruction);
deex  : regn generic map (N => 8) port map (MemDataOut, dataLd, ARESETN, CLK, MemDataOutReged);
ACC   : regn generic map (N => 8) port map (inAcc, accLd, ARESETN, CLK, OutFromAcc);
Disp  : regn generic map (N => 8) port map (OutFromAcc, dispLd, ARESETN, CLK, disp2seg);
Freg  : regn generic map (N => 4) port map (FlagInp, flagLd, ARESETN, CLK, flag2seg);

-- Memoriezz
inst_mem : mem_array generic map (DATA_WIDTH => 12, ADDR_WIDTH => 8) port map (pc, zeroVector_12, CLK, zeroLogic, InstrMemOut);
data_mem : mem_array generic map (DATA_WIDTH => 8, ADDR_WIDTH => 8) port map (Addr, BusOut, CLK, dmWr, MemDataOut);

-- ALUZUZU
alu : alu_wRCA port map (OutFromAcc, BusOut, aluMd, aluOut, aluToFlag(3), aluToFlag(2), aluToFlag(1), aluToFlag(0));

-- RCA
adder : RCA port map (pc, oneVector_8, zeroLogic, PCIncrOut, zeroLogic);

-- MOTTHA CONTROLLER!
pController : procController port map (master_load_enable, Instruction(11 DOWNTO 8), neq, eq, CLK, ARESETN, pcSel, pcLd, instrLd, addrMd, dmWr, dataLd, flagLd, accSel, accLd, im2bus, dmRd, acc2bus, ext2bus, dispLd, aluMd);

END arch;
