----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2018 15:10:53
-- Design Name: 
-- Module Name: manchester_encoder - Behavioral
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

entity manchester_encoder is
Port (hamming: in std_logic_vector(10 downto 0);
    manchester: out std_logic_vector(21 downto 0)
    );
end manchester_encoder;

architecture Behavioral of manchester_encoder is
    component manchester_encoder_unit 
    Port (hamming: in std_logic;
        manchester:out std_logic_vector(1 downto 0)
        );
    end component;
begin
    C1: manchester_encoder_unit port map(hamming(10), manchester(21 downto 20));
    C2: manchester_encoder_unit port map(hamming(9), manchester(19 downto 18));
    C3: manchester_encoder_unit port map(hamming(8), manchester(17 downto 16));
    C4: manchester_encoder_unit port map(hamming(7), manchester(15 downto 14));
    C5: manchester_encoder_unit port map(hamming(6), manchester(13 downto 12));
    C6: manchester_encoder_unit port map(hamming(5), manchester(11 downto 10));
    C7: manchester_encoder_unit port map(hamming(4), manchester(9 downto 8));
    C8: manchester_encoder_unit port map(hamming(3), manchester(7 downto 6));
    C9: manchester_encoder_unit port map(hamming(2), manchester(5 downto 4));
    C10: manchester_encoder_unit port map(hamming(1), manchester(3 downto 2));
    C11: manchester_encoder_unit port map(hamming(0), manchester(1 downto 0));
end Behavioral;
