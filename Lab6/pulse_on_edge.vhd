----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:29:21 12/12/2012 
-- Design Name: 
-- Module Name:    pulse_on_edge - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pulse_on_edge is
    Port ( level_in : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           aresetn : in  STD_LOGIC;
           pulse_out : out  STD_LOGIC);
end pulse_on_edge;

architecture Behavioral of pulse_on_edge is

signal last_value : std_logic;

begin

pulse_out <= last_value xor level_in;

process (clk, aresetn)
begin
if aresetn = '0' then
	last_value <= '0';
else
	if rising_edge(clk) then
		last_value <= level_in;
	end if;
end if;
end process;

end Behavioral;

