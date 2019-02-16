----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2018 19:31:45
-- Design Name: 
-- Module Name: samp_clk - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity samp_clk is
Port (clkin, clk: in std_logic;
    clkout: out std_logic
);
end samp_clk;

architecture Behavioral of samp_clk is
begin
	process(clk)
    begin
        if rising_edge(clk) then
            clkout <= clkin;
        end if;
    end process;


end Behavioral;
