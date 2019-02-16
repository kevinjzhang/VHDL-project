----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2018 11:41:58
-- Design Name: 
-- Module Name: bus_interface_central - Behavioral
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

entity bus_interface_central is
Port (module1, module2, module3, module4, module5, module6: inout std_logic_vector(83 downto 0);
    address_in: in std_logic_vector(4 downto 0);
    address_out: out std_logic_vector(4 downto 0);
    clk: in std_logic
);
end bus_interface_central;

architecture Behavioral of bus_interface_central is

begin
    process(clk)
    begin 
        --connects module1 to module 2
        module1(7 downto 4) <= module2(3 downto 0);
        module2(7 downto 4) <= module1(3 downto 0); 
        module1(9) <= module2(8);
        module2(9) <= module1(8);        
    end process;
end Behavioral;
