----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:48:15 12/12/2012 
-- Design Name: 
-- Module Name:    async_reset_deassert_sync - Behavioral 
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

entity async_reset_deassert_sync is
    Port ( aresetn_in : in  STD_LOGIC;
           aresetn_out : out  STD_LOGIC;
           clk : in  STD_LOGIC);
end async_reset_deassert_sync;

architecture Behavioral of async_reset_deassert_sync is

signal ff1, ff2 : std_logic;

begin


aresetn_out <= ff2;

process (clk, aresetn_in) 
begin
if (aresetn_in = '0') then 
	ff1 <= '0';
	ff2 <= '0';
else 
	if rising_edge(clk) then
		ff1 <= '1';
		ff2 <= ff1;
	end if;
end if;
end process;


end Behavioral;

