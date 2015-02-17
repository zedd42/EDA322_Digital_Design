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


signal accSignal : std_logic_vector(7 downto 0) := "00000000";
signal dispSignal : std_logic_vector(7 downto 0) := "00000000";
signal dMemSignal : std_logic_vector(7 downto 0) := "00000000";
signal pcSignal : std_logic_vector(7 downto 0) := "00000000";
signal flagSignal : std_logic_vector(7 downto 0) := "00000000";

file accFile: text open read_mode is "acctrace.txt";
file dispFile: text open read_mode is "disptrace.txt";
file dmemFile: text open read_mode is "dMemOuttrace.txt";
file pcFile: text open read_mode is "pctrace.txt";
file flagFile: text open read_mode is "flagtrace.txt";

signal accCounter : integer := 0;
signal dispCounter : integer := 0;
signal dmemCounter : integer := 0;
signal flagCounter : integer := 0;
signal pcCounter : integer := 0;

BEGIN
EDA322_dut : EDA322_processor port map (
                externalIn => "00000000",
                CLK => CLK,
                master_load_enable => master_load_enable,
                ARESETN => ARESETN,
                pc2seg => pc2seg, 
                instr2seg => instr2seg, 
                Addr2seg => addr2seg, 
                dMemOut2seg => dMemOut2seg, 
                aluOut2seg => aluOut2seg, 
                acc2seg => acc2seg, 
                flag2seg => flag2seg, 
                busOut2seg => busOut2seg, 
                disp2seg => disp2seg,
                errSig2seg => errSig2seg, 
                ovf => ovf, 
                zero => zero 
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
		ARESETN <= '1'; 
	end if;
end process;   

-- READING PROCESSESZ:/.win/git/digitaldesign/Lab5/EDA322Testbench.vhdl
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
    wait;
end process;

verifyAcc: process(acc2seg)
begin
    if (aresetn = '1' and clk'event and clk = '0') then
        if (acc2seg /= accsignal) then 
            report "Acc ERROR"
            severity error;
        end if;
    end if;
end process;

verifyDisp: process(disp2seg)
begin
    if disp2seg = 144 then
        report "TEST SUCCEEDED"
        severity failure;
    end if;
    if (aresetn = '1' and clk'event and clk = '0') then
        if (disp2seg /= dispsignal) then 
            report "Disp ERROR"
            severity error;
        end if;    
    end if;
end process;

verifydMem: process(dmemout2seg)
begin
    if (aresetn = '1' and clk'event and clk = '0') then
        if (dmemout2seg /= dmemsignal) then 
            report "dMem ERROR"
            severity error;
        end if;
    end if;
end process;

verifyFlag: process(flag2seg)
begin
    if (aresetn = '1' and clk'event and clk = '0') then
        if (flag2seg /= (flagsignal(3 downto 0))) then 
            report "Flag ERROR"
            severity error;
        end if;
    end if;
end process;

verifyPC: process(pc2seg)
begin
    if (aresetn = '1' and clk'event and clk = '0') then
        if (pc2seg /= pcsignal) then 
            report "PC ERROR"
            severity error;
        end if;
    pcCounter <= pcCounter + 1;
    end if;
end process;

--endProcess: process(clk)
--begin
--    if disp2seg = 144 then
--        if not accBool or
--        not dispBool or
--        not dmemBool or
--        not flagBool or
--        not pcBool then
--            report "NOT CORRECT"
--            severity note;
--        else
--            report "TEST SUCCEEDED"
--            severity note;    
--        end if;
--        report "TEST DONE"
--        severity failure;    
--    end if;
--end process;
        
end Behavioral;
