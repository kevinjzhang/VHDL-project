----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2018 15:12:36
-- Design Name: 
-- Module Name: manchester_decoder - Behavioral
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

entity manchester_decoder is
Port ( EN: in std_logic;
       encode_in: in std_logic_vector (1 downto 0);
       decode_out: out std_logic
);
end manchester_decoder;

architecture Behavioral of manchester_decoder is
begin
    manchester: process(EN, encode_in)
    begin
        if EN = '1' then
            if(encode_in(0) = '1') then
                decode_out <= '1';
            else
                decode_out <= '0';
            end if;
        else
            decode_out <= '0';
        end if;
    end process;

end Behavioral;
