library IEEE;
use ieee.std_logic_1164.all;

entity alu_wRCA is
    port ( ALU_inA, ALU_inB :   in  STD_LOGIC_VECTOR(7 DOWNTO 0);
           Operation        :   in  STD_LOGIC_VECTOR(1 DOWNTO 0);
           ALU_out          :   out STD_LOGIC_VECTOR(7 DOWNTO 0);
           Carry, NotEq     :   out STD_LOGIC;
           Eq, isOutZero    :   out STD_LOGIC
         );
end alu_wRCA;

architecture arch of alu_wRCA is

    -- dataflow -- nandOut and notOut
    signal nandOut, notOut  :   STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- structural -- Subtraction or Addition
    signal rcaout, B : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal CIN       : STD_LOGIC;

    component RCA is
        port (A, B  :   in  STD_LOGIC_VECTOR(7 DOWNTO 0);
              CIN   :   in  STD_LOGIC;
              SUM   :   out STD_LOGIC_VECTOR(7 DOWNTO 0);
              COUT  :   out STD_LOGIC
            );
    end component RCA;

    component cmp is
        port (A, B      :   in STD_LOGIC_VECTOR(7 DOWNTO 0);
              EQ, NEQ   :   out STD_LOGIC
             );
    end component cmp;

begin
    -- Init declarations
    nandOut <= not (ALU_inA and ALU_inB);
    notOut  <= not ALU_inA;

    with Operation select
        B  <= ALU_inB xor "11111111" when "01",
              ALU_inB when others;

    with Operation select
        CIN <= Operation(0) when "01",
               Operation(1) when others;
    
    rc :   RCA port map (ALU_inA, B, CIN, rcaout, Carry);
    cp :   cmp port map (ALU_inA, ALU_inB, Eq, NotEq);
    
    -- dataflow -- 4 to 1 mux
    with Operation select
        ALU_out <= rcaout   when "00",
                   rcaout   when "01",
                   nandOut  when "10",
                   notOut   when others;

    -- dataflow -- isZero
    isOutZero <= not (rcaout(0) or rcaout(1) or rcaout(2) or rcaout(3) or 
                      rcaout(4) or rcaout(5) or rcaout(6) or rcaout(7));
end arch;


