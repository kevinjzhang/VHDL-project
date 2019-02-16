----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2018 14:36:57
-- Design Name: 
-- Module Name: hamming_manchester_encoder2 - Behavioral
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

entity hamming_manchester_encoder2 is
    Port (raw: in std_logic_vector(3 downto 0);
        hamming_errors: in std_logic_vector(7 downto 0);
        encode_out: out std_logic_vector(15 downto 0)
    );
end hamming_manchester_encoder2;

architecture Behavioral of hamming_manchester_encoder2 is
    component manchester_encoder 
    Port (hamming: in std_logic_vector(10 downto 0);
        manchester: out std_logic_vector(21 downto 0)
        );
    end component;
    
    component hamming_encoder 
        Port (raw: in std_logic_vector (3 downto 0);
            hamming_errors: in std_logic_vector (7 downto 0); --toggles bit if 1, does nothing otherwise
            hamming: out std_logic_vector (10 downto 0) --Adds start and end bits
        );
    end component;
    
    signal hamming: std_logic_vector(10 downto 0);
    signal encode: std_logic_vector(21 downto 0);
begin
    C1: manchester_encoder port map(hamming, encode);
    C2: hamming_encoder port map(raw, hamming_errors, hamming);
    encode_out <= encode (17 downto 2);

end Behavioral;
