-- Coded by Anurag Negi
-- For EDA321 lab

----------------------------------------------------------------------------------
-- Create Date:    13:16:27 07/12/2012 
-- Design Name: 
-- Module Name:    ssd_decoder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sseg_driver is
port (
          CLK100MEG : in STD_LOGIC; -- 100 MHz clock from V10 pin
			 ARESETN : in STD_LOGIC; -- asynchronous active low reset
			 HEX0_IN  : in STD_LOGIC_VECTOR (3 downto 0);   
			 HEX1_IN  : in STD_LOGIC_VECTOR (3 downto 0);   
			 HEX2_IN  : in STD_LOGIC_VECTOR (3 downto 0);   
			 HEX3_IN  : in STD_LOGIC_VECTOR (3 downto 0);   
			 SSEG_CA : out STD_LOGIC_VECTOR (7 downto 0); -- cathode outputs
			 SSEG_AN : out STD_LOGIC_VECTOR (3 downto 0)  -- anode outputs
);
end entity;

architecture structural of sseg_driver is 
signal HEX_DATA  : STD_LOGIC_VECTOR (3 downto 0);
signal SSEG_AN_INT : STD_LOGIC_VECTOR (3 downto 0);

-- SSDs need to be scanned every 10khz (approx) 
constant TMR_CNTR_MAX : std_logic_vector(13 downto 0) := "10011100010000"; 

signal TMRCOUNTER: std_logic_vector(13 downto 0);


component sseg_decode
-- Code for this component will be provided by students
port(
HEX_DATA: in STD_LOGIC_VECTOR(3 downto 0);
SSEG_CA: out STD_LOGIC_VECTOR(7 downto 0)
);
end component;



begin

with SSEG_AN_INT select
	HEX_DATA <= HEX0_IN when "1110",
					HEX1_IN when "1101",
					HEX2_IN when "1011",
					HEX3_IN when "0111",
					"0000" when others;
	
sseg_decode1 : sseg_decode port map(
	HEX_DATA => HEX_DATA,
	SSEG_CA => SSEG_CA
);	

 


timer_counter_process : process (CLK100MEG, ARESETN)
begin
	if (ARESETN = '0') then 
	    TMRCOUNTER <= (others => '0');
	elsif (rising_edge(CLK100MEG)) then
		if ( TMRCOUNTER = TMR_CNTR_MAX) then
			TMRCOUNTER <= (others => '0');
		else
			TMRCOUNTER <= TMRCOUNTER + 1;
		end if;
	end if;
end process;


sseg_scanner: process (CLK100MEG, ARESETN)
begin
	if (ARESETN = '0') then 
		SSEG_AN_INT <= "1110"; 
	else
		if (rising_edge(CLK100MEG)) then
			if (TMRCOUNTER = TMR_CNTR_MAX) then -- this happens every 10K ticks ... i.e. 10khz
				SSEG_AN_INT <= SSEG_AN_INT(2 downto 0) & SSEG_AN_INT(3); --rotate the enabled sseg
			end if;
		end if;
	end if;
end process;

SSEG_AN <= SSEG_AN_INT;


		
end structural;
