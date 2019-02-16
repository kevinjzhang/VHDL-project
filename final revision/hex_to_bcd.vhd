----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.10.2018 19:42:51
-- Design Name: 
-- Module Name: hex_to_bcd - Behavioral
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
USE ieee.numeric_std.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hex_to_bcd is
    Port ( hex_byte : in STD_LOGIC_vector(7 downto 0);
        bcd_byte: out std_logic_vector(7 downto 0)
    );
end hex_to_bcd;

architecture Behavioral of hex_to_bcd is

begin
    process(hex_byte)
    variable temp: integer range 0 to 255;
    variable dig1, dig2: integer range 0 to 9;
    begin
        temp := to_integer(unsigned(hex_byte));
        dig1 := (temp / 10) mod 10;
        dig2 := temp mod 10;
        bcd_byte(7 downto 4) <= std_logic_vector(to_unsigned(dig1, 4));
        bcd_byte(3 downto 0) <= std_logic_vector(to_unsigned(dig2, 4));
    end process;
end Behavioral;
