-- Muxes to select signals for display on a seven segment display
-- Author: Anurag Negi

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debugmux is
    Port ( sseg_dbg1 : in  STD_LOGIC_VECTOR (3 downto 0);
           sseg_dbg2 : in  STD_LOGIC_VECTOR (3 downto 0);
           sseg_dbg3 : in  STD_LOGIC_VECTOR (3 downto 0);
           sseg_dbg4 : in  STD_LOGIC_VECTOR (3 downto 0);
           dbg_sel : in  STD_LOGIC_VECTOR (1 downto 0);
           sseg_dbg_o : out  STD_LOGIC_VECTOR (3 downto 0));
end debugmux;

architecture Behavioral of debugmux is

begin 

with dbg_sel select 
	  sseg_dbg_o <= sseg_dbg1 when "00",
							sseg_dbg2 when "01",
							sseg_dbg3 when "10",
							sseg_dbg4 when others;

end Behavioral;

