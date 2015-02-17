-- EDA 322 Lab : Top Level Synthesizable Processor Wrapper
-- Author: Anurag Negi
-- Date: 11 Dec 2012

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity proc_top is
    Port ( CLK100MEG : in  STD_LOGIC;
	        CLK_MANUAL: in STD_LOGIC; -- from switch (T5 (SW7)) (check bounce)
           ARESETN_RAW : in  STD_LOGIC;  -- from switch (T10 (SW0))
			  DBG1: in STD_LOGIC_VECTOR(1 downto 0); -- select fom DBG MUX1 (M8(SW3), V9(SW2))
			  DBG2: in STD_LOGIC_VECTOR(1 downto 0); -- select for DBG_MUX2 (U8(SW5), N8(SW4))
           SSEG_CA : out  STD_LOGIC_VECTOR (7 downto 0); 
           SSEG_AN : out  STD_LOGIC_VECTOR (3 downto 0);
			  LED1: out STD_LOGIC; -- PIN U16 (LD0)
			  LED2: out STD_LOGIC; -- PIN V16 (LD1)
			  LED3: out STD_LOGIC  -- PIN U15 (LD2)
			  );
end proc_top;

architecture Behavioral of proc_top is


component sseg_driver
port(
	       CLK100MEG : in STD_LOGIC; -- 100 MHz clock from V10 pin
			 ARESETN : in STD_LOGIC; -- asynchronous active low reset
			 HEX0_IN  : in STD_LOGIC_VECTOR (3 downto 0);   
			 HEX1_IN  : in STD_LOGIC_VECTOR (3 downto 0);   
			 HEX2_IN  : in STD_LOGIC_VECTOR (3 downto 0);   
			 HEX3_IN  : in STD_LOGIC_VECTOR (3 downto 0);   
			 SSEG_CA : out STD_LOGIC_VECTOR (7 downto 0); -- cathode outputs
			 SSEG_AN : out STD_LOGIC_VECTOR (3 downto 0)  -- anode outputs

);
end component;

component EDA322_processor is
    Port ( externalIn : in  STD_LOGIC_VECTOR (7 downto 0);
			  CLK : in STD_LOGIC;
			  master_load_enable: in STD_LOGIC;
			  ARESETN : in STD_LOGIC;
           pc2seg : out  STD_LOGIC_VECTOR (7 downto 0);
           instr2seg : out  STD_LOGIC_VECTOR (11 downto 0);
           Addr2seg : out  STD_LOGIC_VECTOR (7 downto 0);
           dMemOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);
           aluOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);
           acc2seg : out  STD_LOGIC_VECTOR (7 downto 0);
           flag2seg : out  STD_LOGIC_VECTOR (3 downto 0);
           busOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);
			  disp2seg: out STD_LOGIC_VECTOR(7 downto 0);
			  errSig2seg : out STD_LOGIC;
			  ovf : out STD_LOGIC;
			  zero : out STD_LOGIC);
end component;

component debugmux is
    Port ( sseg_dbg1 : in  STD_LOGIC_VECTOR (3 downto 0);
           sseg_dbg2 : in  STD_LOGIC_VECTOR (3 downto 0);
           sseg_dbg3 : in  STD_LOGIC_VECTOR (3 downto 0);
           sseg_dbg4 : in  STD_LOGIC_VECTOR (3 downto 0);
           dbg_sel : in  STD_LOGIC_VECTOR (1 downto 0);
           sseg_dbg_o : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component synch_1bit is
    Port ( clk : in  STD_LOGIC;
			  aresetn : in STD_LOGIC;
           async_in : in  STD_LOGIC;
           sync_out : out  STD_LOGIC);
end component;

component async_reset_deassert_sync is
    Port ( aresetn_in : in  STD_LOGIC;
           aresetn_out : out  STD_LOGIC;
           clk : in  STD_LOGIC);
end component;

component pulse_on_edge is
    Port ( level_in : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           aresetn : in  STD_LOGIC;
           pulse_out : out  STD_LOGIC);
end component;


signal ARESETN : std_logic;

signal pc2seg: std_logic_vector(7 downto 0);
signal addr2seg: std_logic_vector(7 downto 0);
signal instr2seg: std_logic_vector(11 downto 0);
signal dMemOut2seg: std_logic_vector(7 downto 0);
signal aluOut2seg: std_logic_vector(7 downto 0);
signal acc2seg: std_logic_vector(7 downto 0);
signal flag2seg: std_logic_vector(3 downto 0);
signal busOut2seg: std_logic_vector(7 downto 0);
signal disp2seg: STD_LOGIC_VECTOR(7 downto 0);
signal errSig2seg: std_logic;
signal ovf: std_logic;
signal zero: std_logic;

signal HEX0 : std_logic_vector(3 downto 0);
signal HEX1 : std_logic_vector(3 downto 0);
signal HEX2 : std_logic_vector(3 downto 0);
signal HEX3 : std_logic_vector(3 downto 0);

signal DBG1_sync : std_logic_vector(1 downto 0);
signal DBG2_sync : std_logic_vector(1 downto 0);

signal DBG1_sync_0 : std_logic;
signal DBG1_sync_1 : std_logic;
signal DBG2_sync_0 : std_logic;
signal DBG2_sync_1 : std_logic;




signal en_sync_level : std_logic; --convert this to pulse on edge;
signal en_sync: std_logic;

begin


EDA322_processor_inst1 : EDA322_processor port map (
			  externalIn => "00000000",
			  CLK => CLK100MEG,
			  master_load_enable => en_sync, -- flipflop load enables for single step mode
			  ARESETN =>ARESETN,
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
			  
sseg_driver1 : sseg_driver port map(
	CLK100MEG => CLK100MEG,
	ARESETN => ARESETN,
	HEX0_IN => HEX0,
	HEX1_IN => HEX1,
	HEX2_IN => HEX2,
	HEX3_IN => HEX3,
	SSEG_CA => SSEG_CA,
	SSEG_AN => SSEG_AN
	);

			  
--Switch Modes
--DBGMUX1&2 (SW3 & SW2)
--		00: instr (7 downto 0)
-- 	01: dMemOut
--		10: Addr
--    11: ACC

--DBGMUX3&4 (SW5 & SW4)
--    00: {flags, Bits 11-8 of instr} (Opcode)
--  	01: PC
-- 	10: bus
--    11: disp


DBG1_sync <= (DBG1_sync_1 & DBG1_sync_0);

DBG2_sync <= (DBG2_sync_1 & DBG2_sync_0);

synch1:  synch_1bit port map(
		  clk => CLK100MEG,
		  aresetn => ARESETN,
		  async_in => DBG1(0),
		  sync_out => DBG1_sync_0
);

synch2:  synch_1bit port map(
		  clk => CLK100MEG,
		  aresetn => ARESETN,
		  async_in => DBG1(1),
		  sync_out => DBG1_sync_1
);

synch3:  synch_1bit port map(
		  clk => CLK100MEG,
		  aresetn => ARESETN,
		  async_in => DBG2(0),
		  sync_out => DBG2_sync_0
);

synch4:  synch_1bit port map(
		  clk => CLK100MEG,
		  aresetn => ARESETN,
		  async_in => DBG2(1),
		  sync_out => DBG2_sync_1
);

synch5:  synch_1bit port map(
		  clk => CLK100MEG,
		  aresetn => ARESETN,
		  async_in => CLK_MANUAL,
		  sync_out => en_sync_level
);

edge_detect1: pulse_on_edge port map(
			level_in => en_sync_level,
			clk => CLK100MEG,
			aresetn => ARESETN,
			pulse_out => en_sync
);

async_reset_deassert_sync_inst1 : async_reset_deassert_sync port map(
			aresetn_in => ARESETN_RAW,
			aresetn_out => ARESETN, 
			clk => CLK100MEG
);

			  
dbgmux1: debugmux port map (
			  sseg_dbg1 => instr2seg(3 downto 0),
           sseg_dbg2 => dMemOut2seg(3 downto 0),
           sseg_dbg3 => addr2seg(3 downto 0),
           sseg_dbg4 => acc2seg(3 downto 0),
           dbg_sel => DBG1_sync,
           sseg_dbg_o => HEX1);

dbgmux2: debugmux port map (
			  sseg_dbg1 => instr2seg(7 downto 4),
           sseg_dbg2 => dMemOut2seg(7 downto 4),
           sseg_dbg3 => addr2seg(7 downto 4),
           sseg_dbg4 => acc2seg(7 downto 4),
           dbg_sel => DBG1_sync,
           sseg_dbg_o => HEX0);


dbgmux3: debugmux port map (
			  sseg_dbg1 => instr2seg(11 downto 8), --opcode
           sseg_dbg2 => pc2seg(3 downto 0),
           sseg_dbg3 => busOut2seg(3 downto 0),
           sseg_dbg4 => disp2seg(3 downto 0),
           dbg_sel => DBG2_sync,
           sseg_dbg_o => HEX3);

dbgmux4: debugmux port map (
			  sseg_dbg1 => flag2seg,
           sseg_dbg2 => pc2seg(7 downto 4),
           sseg_dbg3 => busOut2seg(7 downto 4),
           sseg_dbg4 => disp2seg(7 downto 4),
           dbg_sel => DBG2_sync,
           sseg_dbg_o => HEX2);
			  
LED1 <= errSig2seg;
LED2 <= ovf;
LED3 <= zero;

end Behavioral;

