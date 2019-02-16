----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2018 16:11:07
-- Design Name: 
-- Module Name: manchester_hamming_decoder - Behavioral
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

entity manchester_hamming_decoder is
Port (EN: in std_logic;
    encode_in: in std_logic_vector(15 downto 0);
    decode_out: out std_logic_vector(3 downto 0);
    errors: out std_logic_vector(1 downto 0);
    manchester_test: out std_logic_vector(7 downto 0) 
);
end manchester_hamming_decoder;

architecture Behavioral of manchester_hamming_decoder is

component hamming_decoder 
Port ( encode_in: in std_logic_vector (7 downto 0);
       decode_out: out std_logic_vector (3 downto 0);
       errors: out std_logic_vector(1 downto 0) -- erros(1) is MSB
);
end component;

component manchester_decoder_cascaded 
Port ( EN: in std_logic;
       encode_in: in std_logic_vector (15 downto 0);
       decode_out: out std_logic_vector (7 downto 0)
);
end component;

signal manchester: std_logic_vector(7 downto 0);
begin
    C1: manchester_decoder_cascaded port map(EN, encode_in, manchester);
    C2: hamming_decoder port map(manchester, decode_out, errors);

    manchester_test <= manchester;
end Behavioral;
