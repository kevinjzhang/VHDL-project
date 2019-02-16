----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2018 15:22:53
-- Design Name: 
-- Module Name: manchester_decoder_cascaded - Behavioral
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

entity manchester_decoder_cascaded is
Port ( EN: in std_logic;
       encode_in: in std_logic_vector (15 downto 0);
       decode_out: out std_logic_vector (7 downto 0)
);
end manchester_decoder_cascaded;

architecture Behavioral of manchester_decoder_cascaded is

component manchester_decoder 
Port ( EN: in std_logic;
       encode_in: in std_logic_vector (1 downto 0);
       decode_out: out std_logic
);
end component;
    
begin
C1: manchester_decoder port map(EN, encode_in(15 downto 14), decode_out(7));
C2: manchester_decoder port map(EN, encode_in(13 downto 12), decode_out(6));
C3: manchester_decoder port map(EN, encode_in(11 downto 10), decode_out(5));
C4: manchester_decoder port map(EN, encode_in(9 downto 8), decode_out(4));
C5: manchester_decoder port map(EN, encode_in(7 downto 6), decode_out(3));
C6: manchester_decoder port map(EN, encode_in(5 downto 4), decode_out(2));
C7: manchester_decoder port map(EN, encode_in(3 downto 2), decode_out(1));
C8: manchester_decoder port map(EN, encode_in(1 downto 0), decode_out(0));
end Behavioral;
