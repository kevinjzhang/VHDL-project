----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.10.2018 17:19:43
-- Design Name: 
-- Module Name: test_encoder - Behavioral
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

entity test_encoder is
--  Port ( );
end test_encoder;

architecture Behavioral of test_encoder is

    component hamming_manchester_encoder 
    Port (raw: in std_logic_vector(3 downto 0);
        hamming_test: out std_logic_vector(10 downto 0);
        hamming_errors: in std_logic_vector(7 downto 0);
        encode_out: out std_logic_vector(21 downto 0)
        );
    end component;

    signal raw: std_logic_vector(3 downto 0);
    signal hamming_test: std_logic_vector(10 downto 0);
    signal hamming_errors: std_logic_vector(7 downto 0);
    signal encode_out: std_logic_vector(21 downto 0);
begin
    uut: hamming_manchester_encoder port map(raw, hamming_test, hamming_errors, encode_out);

    input_gen: process
    begin
        hamming_errors <= "00000000";
        raw <= "0000";
        wait for 10ns;
        hamming_errors <= "00000000";
        raw <= "1000";
        wait for 10ns;
        hamming_errors <= "00000000";
        raw <= "0101";
        wait for 10ns;            
    end process;
end Behavioral;
