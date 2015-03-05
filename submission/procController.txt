library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity procController is
    Port ( 	master_load_enable: in STD_LOGIC;
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
				aluMd : out STD_LOGIC_VECTOR(1 downto 0));
end procController;

architecture Behavioral of procController is

    type state_type is (FE, DE, DES, EX, ME);
    signal current_state, next_state : state_type;
    signal v_control : STD_LOGIC_VECTOR(15 DOWNTO 0);

begin

    pcsel    <= v_control(0) and (master_load_enable);
    pcld     <= v_control(1) and (master_load_enable );
    instrld  <= v_control(2) and (master_load_enable);
    addrmd   <= v_control(3) and (master_load_enable);
    dmwr     <= v_control(4) and (master_load_enable);
    datald   <= v_control(5) and (master_load_enable);
    flagld   <= v_control(6) and (master_load_enable);
    accsel   <= v_control(7) and (master_load_enable);
    accld    <= v_control(8) and (master_load_enable );
    im2bus   <= v_control(9) and (master_load_enable );
    dmrd     <= v_control(10) and (master_load_enable);
    acc2bus  <= v_control(11) and (master_load_enable );
    ext2bus  <= v_control(12) and (master_load_enable );
    displd   <= v_control(13) and (master_load_enable);
    alumd(1) <= v_control(14) and (master_load_enable);
    alumd(0) <= v_control(15) and (master_load_enable);

process(CLK, ARESETN)
begin
if ARESETN = '0' then
	current_state <= FE;
else
    if (CLK='1' and CLK'EVENT) then
        if master_load_enable = '1' then
		    current_state <= next_state;
        end if;
    end if;
end if;
end process;

process(current_state, opcode)
begin    
    case current_state is
        when FE =>
            next_state <= DE;
        when DE =>
            case opcode is
            when "0000" => next_state <= EX;
            when "0001" => next_state <= EX;
            when "0010" => next_state <= EX;
            when "0011" => next_state <= EX;
            when "0100" => next_state <= EX;
            when "0101" => next_state <= EX;
            when "0110" => next_state <= EX;
            when "0111" => next_state <= ME;
            when "1000" => next_state <= DES;
            when "1001" => next_state <= DES;
            when "1010" => next_state <= DES;
            when "1011" => next_state <= FE;
            when "1100" => next_state <= FE;
            when "1101" => next_state <= FE;
            when "1110" => next_state <= FE;
            when "1111" => next_state <= EX;
            when others => next_state <= FE;
            end case;
        when DES =>
            case opcode is
            when "1000" => next_state <= EX;
            when "1001" => next_state <= EX;
            when "1010" => next_state <= ME;
            when others => next_state <= FE;
            end case;
        when EX =>
            next_state <= FE;
        when others =>
            next_state <= FE;
    end case;
end process;

process(current_state, opcode, neq, eq)
begin
    case opcode is
        when "0000" =>
            case current_state is
                when FE =>
                    v_control <= (2 => '1', others => '0');
                when DE =>
                    v_control <= (2 | 5 => '1', others => '0');
                when EX =>
                    v_control <= (1 | 2 | 6 | 8 | 10 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');
            end case;
        when "0001" =>
            case current_state is
                when FE =>
                    v_control <= (2 => '1', others => '0');
                when DE =>
                    v_control <= (2 | 5 => '1', others => '0');
                when EX =>
                    v_control <= (1 | 2 | 6 | 8 | 10 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					 
            end case;

       when "0010" =>
            case current_state is
                when FE =>
                    v_control <= (2 | 15 => '1', others => '0');
                when DE =>
                    v_control <= (2 | 5 | 15=> '1', others => '0');
                when EX =>
                    v_control <= (1 | 2 | 6 | 8 | 10 | 15 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');
            end case;

       when "0011" =>
            case current_state is
                when FE =>
                    v_control <= (2 | 14 => '1', others => '0');
                when DE =>
                    v_control <= (2 | 5 | 14 => '1', others => '0');
                when EX =>
                    v_control <= (1 | 2 | 6 | 8 | 10 | 14 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					
            end case;

       when "0100" =>
            case current_state is
                when FE =>
                    v_control <= (2 | 14 | 15 => '1', others => '0');
                when DE =>
                    v_control <= (2 | 5 | 14 | 15 => '1', others => '0');
                when EX =>
                    v_control <= (1 | 2 | 6 | 8 | 10 | 14 | 15 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					 
            end case;

       when "0101" =>
            case current_state is
                when FE =>
                    v_control <= (2 => '1', others => '0');
                when DE =>
                    v_control <= (2 | 5 => '1', others => '0');
                when EX =>
                    v_control <= (1 | 2 | 6 | 10 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					 
            end case;

       when "0110" =>
            case current_state is
                when FE =>
                    v_control <= (2 => '1', others => '0');
                when DE =>
                    v_control <= (2 | 5 => '1', others => '0');
                when EX =>
                    v_control <= (1 | 2 | 7 | 8 | 10 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					 
            end case;

       when "0111" =>
            case current_state is
                when FE =>
                    v_control <= (2 | 11 => '1', others => '0');
                when DE =>
                    v_control <= (2 | 11 => '1', others => '0');
                when ME =>
                    v_control <= (1 | 4 | 2 | 11 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					 
            end case;

       when "1000" =>
            case current_state is
                when FE =>
                    v_control <= (2 => '1', others => '0');
                when DE =>
                    v_control <= (2 | 5 => '1', others => '0');
                when DES =>
                    v_control <= (2 | 3 | 5 => '1', others => '0');
                when EX =>
                    v_control <= (1 | 2 | 6 | 8 | 10 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					 
            end case;

       when "1001" =>
            case current_state is
                when FE =>
                    v_control <= (2 => '1', others => '0');
                when DE =>
                    v_control <= (2 | 5 => '1', others => '0');
                when DES =>
                    v_control <= (2 | 3 | 5 => '1', others => '0');
                when EX =>
                    v_control <= (1 | 2 | 7 | 8 | 10 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					 
            end case;

       when "1010" =>
            case current_state is
                when FE =>
                    v_control <= (2 | 11 => '1', others => '0');
                when DE =>
                    v_control <= (2 | 5 | 11 => '1', others => '0');
                when ME =>
                    v_control <= (1 | 2 | 3 | 4 | 11 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					 
            end case;

       when "1011" =>
            case current_state is
                when FE =>
                    v_control <= (2 | 12 => '1', others => '0');
                when DE =>
                    v_control <= (1 | 2 | 4 | 12 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					 
            end case;

       when "1100" =>
            case current_state is
                when FE =>
                    v_control <= (2 | 9 => '1', others => '0');
                when DE =>
                    v_control <= (0 | 1 | 2 | 9 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					 
            end case;

       when "1101" =>
            case current_state is
                when FE =>
                    v_control <= (2 | 9 => '1', others => '0');
                when DE =>
                    v_control <= (0 => eq, 1 | 2 | 9 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					 
            end case;

       when "1110" =>
            case current_state is
                when FE =>
                    v_control <= (2 | 9 => '1', others => '0');
                when DE =>
                    v_control <= (0 => neq, 1 | 2 | 9 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					 
            end case;

       when others =>
            case current_state is
                when FE =>
                    v_control <= (2 => '1', others => '0');
                when DE =>
                    v_control <= (2 => '1', others => '0');
                when EX =>
                    v_control <= (1 | 2 | 13 => '1', others => '0');
                when others =>
					     v_control <= (others => '0');					 
            end case;
    end case; 
end process;

end Behavioral;
