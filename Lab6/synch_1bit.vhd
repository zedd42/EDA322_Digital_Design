library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity synch_1bit is
    Port ( clk : in  STD_LOGIC;
			  aresetn : in STD_LOGIC;
           async_in : in  STD_LOGIC;
           sync_out : out  STD_LOGIC);
end synch_1bit;

architecture Behavioral of synch_1bit is

signal int_level1, int_level2 : std_logic;


begin

sync_out <= int_level2;

synch: process(clk, aresetn)
begin
if aresetn = '0' then
	int_level1 <= '0';
	int_level2 <= '0';
else 
	if rising_edge(clk) then
		int_level1 <= async_in;
		int_level2 <= int_level1;
	end if;
end if;
end process;

end Behavioral;

