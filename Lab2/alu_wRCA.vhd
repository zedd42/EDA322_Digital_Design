library IEEEE;
use ieee.std_logic_1164.all;

entity alu_wRCA is
    port ( ALU_inA, ALU_inB :   in  STD_LOGIC_VECTOR(7 DOWNTO 0);
           Operation        :   in  STD_LOGIC_VECTOR(1 DOWNTO 0);
           ALU_out          :   out STD_LOGIC_VECTOR(7 DOWNTO 0);
           Carry, isOutZero :   out STD_LOGIC;
           NotEq, Eq        :   out STD_LOGIC
         );
end alu_wRCA;

architecture arch of alu_wRCA is

    -- dataflow -- nandOut and notOut
    signal nandOut, notOut  :   STD_LOGIC_VECTOR(7 DOWNTO 0);

    nandOut <= A not(A and B);
    notOut  <= not A;

    -- structural -- Subtraction or Addition
    signal rcaout : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    component RCA is
        port (A, B  :   in  STD_LOGIC_VECTOR(7 DOWNTO 0);
              CIN   :   in  STD_LOGIC;
              SUM   :   out STD_LOGIC_VECTOR(7 DOWNTO 0);
              COUT  :   out STD_LOGIC;
            );
    end component RCA;

    component cmp is
        port (A, B      :   in STD_LOGIC_VECTOR(7 DOWNTO 0);
              EQ, NEQ   :   out STD_LOGIC
             );
    end component cmp;

begin
    with Opeartion select
        B  <= ALU_inB xor "11111111" when "01",
              ALU_inB when others;

    with Operation select
        CIN <= '1' when "01",
               '0' others;
    
    rc :   RCA port map (ALU_inA, B, CIN, rcaout, Carry;
    cp :   cmp port map (ALU_inA, ALU_inB, Eq, NotEq);
    
    -- dataflow -- 4 to 1 mux
    with Operation select
        ALU_out <= rcaout   when "00",
                   rcaout   when "01",
                   nandOut  when "10",
                   notOut   when others;

    -- dataflow -- isZero
    isOutZero <= '1' when SUM = "00000000" else '1';

end arch;


