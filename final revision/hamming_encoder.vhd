----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2018 15:10:24
-- Design Name: 
-- Module Name: hamming_encoder - Behavioral
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

entity hamming_encoder is
    Port (raw: in std_logic_vector (3 downto 0);
        hamming_errors: in std_logic_vector (7 downto 0); --toggles bit if 1, does nothing otherwise
        hamming: out std_logic_vector (10 downto 0) --Adds start and end bits
    );
end hamming_encoder;

architecture Behavioral of hamming_encoder is    
begin
    hamming_encode: process(raw, hamming_errors)
    variable raw_lsb: std_logic_vector(3 downto 0);
    variable y: std_logic_vector (10 downto 0);
    variable error_mask: std_logic_vector (10 downto 0);
    begin
        raw_lsb(3) := raw(0);
        raw_lsb(2) := raw(1);
        raw_lsb(1) := raw(2);
        raw_lsb(0) := raw(3);
        
        y(10 downto 9) := "11";
        y(0) := '0';
        y(7) := raw_lsb(2) xor raw_lsb(1) xor raw_lsb(0);
        y(6) := raw_lsb(3) xor raw_lsb(1) xor raw_lsb(0);
        y(5) := raw_lsb(3) xor raw_lsb(2) xor raw_lsb(0);
        y(4 downto 1) := raw_lsb;
        y(8) := y(7) xor y(6) xor y(5) xor y(4) xor y(3) xor y(2) xor y(1);
        
        error_mask(10 downto 9) := "00";
        error_mask(0) := '0';
        error_mask(8 downto 1) := hamming_errors;
        hamming <= y xor error_mask;
    end process;

end Behavioral;
