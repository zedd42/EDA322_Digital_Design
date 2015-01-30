LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
USE ieee.NUMERIC_STD.all;
USE STD.TEXTIO.all;

ENTITY mem_array is
    GENERIC ( DATA_WIDTH    :   INTEGER := 12;
              ADDR_WIDTH    :   INTEGER := 8;
              INIT_FILE     :   STRING  := "inst_mem.mif"
          );
    PORT ( ADDR     :   IN  STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
           DATAIN   :   IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
           CLK      :   IN  STD_LOGIC;
           WE       :   IN  STD_LOGIC;
           OUTPUT   :   OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
       );
end mem_array;
ARCHITECTURE arch of mem_array is

    TYPE MEMORY_ARRAY IS ARRAY (2**ADDR_WIDTH-1 DOWNTO 0) OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

    impure function init_memory_wfile(mif_file_name : in string) return MEMORY_ARRAY is
        file mif_file : text open read_mode is mif_file_name;
        variable mif_line : line;
        variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
        variable temp_mem : MEMORY_ARRAY;
    begin
        for i in MEMORY_ARRAY'range loop
            readline(mif_file, mif_line);
            read(mif_line, temp_bv);
            temp_mem(i) := to_stdlogicvector(temp_bv);
        end loop;
        return temp_mem;
    end function;    
    
    SIGNAL MEM_SIGNAL : MEMORY_ARRAY := init_memory_wfile(INIT_FILE);
    SIGNAL READ_ADDRESS : STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);

BEGIN
    RW: PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF WE = '1' THEN
                MEM_SIGNAL(to_integer(unsigned(ADDR))) <= DATAIN;
            ELSE
                OUTPUT <= MEM_SIGNAL(to_integer(unsigned(ADDR)));
            END IF;
        END IF;
    END PROCESS RW;
END arch;