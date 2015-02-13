library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity EDA322Testbench is
end EDA322Testbench;

architecture Behavioral of EDA322Testbench is

component EDA322_processor is
    Port ( externalIn         : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK                : in  STD_LOGIC;
           master_load_enable : in  STD_LOGIC;
           ARESETN            : in  STD_LOGIC;
           pc2seg             : out STD_LOGIC_VECTOR (7 downto 0);
           instr2seg          : out STD_LOGIC_VECTOR (11 downto 0);
           Addr2seg           : out STD_LOGIC_VECTOR (7 downto 0);
           dMemOut2seg        : out STD_LOGIC_VECTOR (7 downto 0);
           aluOut2seg         : out STD_LOGIC_VECTOR (7 downto 0);
           acc2seg            : out STD_LOGIC_VECTOR (7 downto 0);
           flag2seg           : out STD_LOGIC_VECTOR (3 downto 0);
           busOut2seg         : out STD_LOGIC_VECTOR (7 downto 0);
           disp2seg           : out STD_LOGIC_VECTOR(7 downto 0);
           errSig2seg         : out STD_LOGIC;
           ovf                : out STD_LOGIC;
           zero               : out STD_LOGIC
          );
end component;

constant clkperiod: time := 10 ns;

signal test_time_step : integer := 0;
signal CLK:  std_logic := '0';
signal ARESETN:  std_logic := '0';
signal master_load_enable:  std_logic := '0';

signal pc2seg: std_logic_vector(7 downto 0);
signal addr2seg: std_logic_vector(7 downto 0);
signal instr2seg: std_logic_vector(11 downto 0);
signal dMemOut2seg: std_logic_vector(7 downto 0);
signal aluOut2seg: std_logic_vector(7 downto 0);
signal acc2seg: std_logic_vector(7 downto 0);
signal flag2seg: std_logic_vector(3 downto 0);
signal busOut2seg: std_logic_vector(7 downto 0);
signal disp2seg: std_logic_vector(7 downto 0);
signal errSig2seg: std_logic;
signal ovf: std_logic;
signal zero: std_logic;


signal accSignal : std_logic_vector(7 downto 0);
signal dispSignal : std_logic_vector(7 downto 0);
signal dMemSignal : std_logic_vector(7 downto 0);
signal pcSignal : std_logic_vector(7 downto 0);
signal flagSignal : std_logic_vector(7 downto 0);

file accFile: text open read_mode is "acctrace.txt";
file dispFile: text open read_mode is "disptrace.txt";
file dmemFile: text open read_mode is "dMemOuttrace.txt";
file pcFile: text open read_mode is "pctrace.txt";
file flagFile: text open read_mode is "flagtrace.txt";

signal accEOF : boolean := false;
signal dispEOF : boolean := false;
signal dmemEOF : boolean := false;
signal flagEOF : boolean := false;
signal pcEOF : boolean := false;

signal accCounter : integer := 0;
signal dispCounter : integer := 0;
signal dmemCounter : integer := 0;
signal flagCounter : integer := 0;
signal pcCounter : integer := 0;

signal accBool : boolean := true;
signal dispBool : boolean := true;
signal dmemBool : boolean := true;
signal flagBool : boolean := true;
signal pcBool : boolean := true;

BEGIN
EDA322_dut : EDA322_processor port map (
                externalIn => "00000000",
                CLK => CLK,
                master_load_enable => master_load_enable,
                ARESETN => ARESETN,
                pc2seg => pc2seg, -- 8 bit
                instr2seg => instr2seg, -- 12 bit
                Addr2seg => addr2seg, --8 bit
                dMemOut2seg => dMemOut2seg, -- 8 bit
           aluOut2seg => aluOut2seg, -- 8 bit
           acc2seg => acc2seg, --8 bit
           flag2seg => flag2seg, -- 4bit
           busOut2seg => busOut2seg, -- 8 bit
	   disp2seg => disp2seg, -- 8 bit
	   errSig2seg => errSig2seg, -- 1 bit -- to LED
	   ovf => ovf, --1 bit -- to LED
	   zero => zero -- 1 bit -- to LED
	  );


-- Get the party started
CLK <= not CLK after clkperiod/2; -- CLK with period of 100ns

process (CLK)
begin
	if rising_edge(CLK) then
		test_time_step <= test_time_step + 1;
		master_load_enable <= not master_load_enable;
	else
		master_load_enable <= not master_load_enable;
	end if;
	if test_time_step = 2 then
		ARESETN <= '1'; -- release reset
	end if;
end process;   

-- READING PROCESSES
readAcc: PROCESS
    variable accLine: line;
    variable accData: bit_vector(7 downto 0);
begin    
    for i in 1 to 30 loop
        wait until (aresetn = '1' and clk'event and clk = '1');
        readline(accFile, accLine);
        read(accLine, accData);
        wait until (acc2seg'ACTIVE);
        accSignal <= to_stdlogicvector(accData);
    end loop;
    accEOF <= true;
    wait;
end process;

readDisp: PROCESS
    variable fline: line;
    variable data: bit_vector(7 downto 0);
begin    
    for i in 1 to 10 loop
        wait until (aresetn = '1' and clk'event and clk = '1');
        readline(dispFile, fline);
        read(fline, data);
        wait until(disp2seg'ACTIVE);
        dispSignal <= to_stdlogicvector(data);
    end loop;
    dispEOF <= true;
    wait;
end process;

readdMem: PROCESS
    variable fline: line;
    variable data: bit_vector(7 downto 0);
begin    
    for i in 1 to 20 loop
        wait until (aresetn = '1' and clk'event and clk = '1');
        readline(dMemFile, fline);
        read(fline, data);
        wait until (dMemOut2seg'active);
        dMemSignal <= to_stdlogicvector(data);
    end loop;
    dmemEOF <= true;
    wait;
end process;

readFlag: PROCESS
    variable fline: line;
    variable data: bit_vector(7 downto 0);
begin    
    for i in 1 to 20 loop
        wait until (aresetn = '1' and clk'event and clk = '1');
        readline(flagfile, fline);
        read(fline, data);
        wait until (flag2seg'active);
        flagSignal <= to_stdlogicvector(data);
    end loop;
    flagEOF <= true;
    wait;
end process;

readPC: PROCESS
    variable fline: line;
    variable data: bit_vector(7 downto 0);
begin    
    for i in 1 to 66 loop
        wait until (aresetn = '1' and clk'event and clk = '1');
        readline(pcFile, fline);
        read(fline, data);
        wait until (pc2seg'active);
        pcSignal <= to_stdlogicvector(data);
    end loop;
    pcEOF <= true;
    wait;
end process;

verifyAcc: process(acc2seg)
begin
    if (not accEOF and aresetn = '1' and acc2seg /= "00000000" and clk'event and clk = '0') then
        if (acc2seg /= accsignal) then 
            accBool <= accBool and false;
            report "Acc ERROR"
            severity error;
        else
            accBool <= accBool and true;
        end if;
    end if;
end process;

verifyDisp: process(clk)
begin
    if (not dispEOF and aresetn = '1' and disp2seg /= "00000000" and clk'event and clk = '0') then
        if (disp2seg /= dispsignal) then 
            dispBool <= dispBool and false;
            report "Disp ERROR"
            severity error;
        else
            dispBool <= dispBool and true;
        end if;
    end if;
end process;

verifydMem: process(clk)
begin
    if (not dmemEOF and aresetn = '1' and disp2seg /= "00000000" and clk'event and clk = '0') then
        if (dmemout2seg /= dmemsignal) then 
            dmemBool <= dmemBool and false;
            report "dMem ERROR"
            severity error;
        else
            dmemBool <= dmemBool and true;
        end if;
    end if;
end process;

verifyFlag: process(clk)
begin
    if (not flagEOF and aresetn = '1' and flag2seg /= "0000" and clk'event and clk = '0') then
        if (flag2seg /= (flagsignal(3 downto 0))) then 
--            flagBool <= flagBool and false;
--            report "Flag ERROR"
--            severity error;
        else
            flagBool <= flagBool and true;
        end if;
    end if;
end process;

verifyPC: process(clk)
begin
    if (not pcEOF and aresetn = '1' and pc2seg /= "00000000" and clk'event and clk = '0') then
        if (pc2seg /= pcsignal) then 
            pcBool <= pcBool and false;    
            report "PC ERROR"
            severity error;
        else
            pcBool <= pcBool and true;
        end if;
    pcCounter <= pcCounter + 1;
    end if;
end process;

endProcess: process(clk)
begin
    if accEOF and dispEOF and dmemEOF and flagEOF and pcEOF then
        if not accBool or
        not dispBool or
        not dmemBool or
        not flagBool or
        not pcBool then
            report "NOT CORRECT"
            severity note;
        else
            report "TEST SUCCEEDED"
            severity note;    
        end if;
        report "TEST DONE"
        severity failure;    
    end if;
end process;
        
end Behavioral;
