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
CLK <= not CLK after 5 ns; -- CLK with period of 10ns

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
        wait until (clk'event and clk = '1');
        readline(accFile, accLine);
        read(accLine, accData);
        accSignal <= to_stdlogicvector(accData);
        wait until (acc2seg'ACTIVE);
    end loop;
    wait;
end process;

readDisp: PROCESS
    variable fline: line;
    variable data: bit_vector(7 downto 0);
begin    
    for i in 1 to 10 loop
        wait until (clk'event and clk = '1');
        readline(dispFile, fline);
        read(fline, data);
        dispSignal <= to_stdlogicvector(data);
    end loop;
    wait;
end process;

readdMem: PROCESS
    variable fline: line;
    variable data: bit_vector(7 downto 0);
begin    
    for i in 1 to 20 loop
        wait until (clk'event and clk = '1');
        readline(dMemFile, fline);
        read(fline, data);
        dMemSignal <= to_stdlogicvector(data);
    end loop;
    wait;
end process;

readFlag: PROCESS
    variable fline: line;
    variable data: bit_vector(7 downto 0);
begin    
    for i in 1 to 20 loop
        wait until (clk'event and clk = '1');
        readline(flagfile, fline);
        read(fline, data);
        flagSignal <= to_stdlogicvector(data);
    end loop;
    wait;
end process;

readPC: PROCESS
    variable fline: line;
    variable data: bit_vector(7 downto 0);
begin    
    for i in 1 to 66 loop
        wait until (clk'event and clk = '1');
        readline(pcFile, fline);
        read(fline, data);
        pcSignal <= to_stdlogicvector(data);
    end loop;
    wait;
end process;

verify: process(clk)
variable errormsg:line;
begin
    if (clk'event and clk = '0') then
        if --(pc2seg  /= pcsignal) or
           (acc2seg /= accsignal) 
          -- (disp2seg /= dispsignal) or
         --  (dmemout2seg /= dmemsignal) or
        --   (flag2seg /= flagsignal(3 downto 0)) 
then
            report "ERROR"
            severity note;
        else
            report "ALIVE"
            severity note;
        end if;
    end if;
end process;
end Behavioral;