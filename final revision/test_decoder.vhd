----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2018 15:35:37
-- Design Name: 
-- Module Name: test_decoder - Behavioral
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

entity test_decoder is
--  Port ( );
end test_decoder;

architecture Behavioral of test_decoder is
    component manchester_hamming_decoder 
    Port (EN: in std_logic;
        encode_in: in std_logic_vector(15 downto 0);
        decode_out: out std_logic_vector(3 downto 0);
        errors: out std_logic_vector(1 downto 0);
        manchester_test: out std_logic_vector(7 downto 0)  
    );
    end component;
    
    signal EN: std_logic;
    signal encode_in: std_logic_vector(15 downto 0);
    signal manchester_test: std_logic_vector(7 downto 0); 
    signal decode_out: std_logic_vector(3 downto 0);
    signal errors: std_logic_vector(1 downto 0);    
begin
uut: manchester_hamming_decoder port map(EN, encode_in, decode_out, errors, manchester_test);

input_gen: process
begin
    EN <= '1';
    encode_in <= "0101010101010101";
    wait for 10ns;
    encode_in <= "1001100101101001";
    wait for 10ns;
end process;

end Behavioral;
