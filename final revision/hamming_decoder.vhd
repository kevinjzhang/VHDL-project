----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2018 15:11:48
-- Design Name: 
-- Module Name: hamming_decoder - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hamming_decoder is
Port ( encode_in: in std_logic_vector (7 downto 0);
       decode_out: out std_logic_vector (3 downto 0);
       errors: out std_logic_vector(1 downto 0) -- erros(1) is MSB
);
end hamming_decoder;

architecture Behavioral of hamming_decoder is

    signal decode: std_logic_vector (3 downto 0);
begin
    decode_out(0) <= decode(3);
    decode_out(1) <= decode(2);
    decode_out(2) <= decode(1);
    decode_out(3) <= decode(0);

    decoder: process(encode_in)
    variable syndrome: std_logic_vector(2 downto 0); --syndrome(2) is most sig
    variable parity: std_logic;
    variable error: integer;
    begin
        syndrome(2) := encode_in(6) xor encode_in(2) xor encode_in(1) xor encode_in(0);
        syndrome(1) := encode_in(5) xor encode_in(3) xor encode_in(1) xor encode_in(0);
        syndrome(0) := encode_in(4) xor encode_in(3) xor encode_in(2) xor encode_in(0);
        parity := encode_in(7) xor encode_in(6) xor encode_in(5) xor encode_in(4) xor encode_in(3) 
                xor encode_in(2) xor encode_in(1) xor encode_in(0);
        if(parity = '0' and syndrome /= "000") then
            error := 2;
        else
            error := 1;
        end if;
        
        if(syndrome = "000") then
            error := error - 1;
            decode <= encode_in(3 downto 0);
        elsif(error = 2) then
            decode <= "0000";
        elsif(syndrome = "011") then
            decode <= encode_in(3 downto 0) xor "1000";
        elsif(syndrome = "101") then
            decode <= encode_in(3 downto 0) xor "0100";
        elsif(syndrome = "110") then
            decode <= encode_in(3 downto 0) xor "0010";
        elsif(syndrome = "111") then
            decode <= encode_in(3 downto 0) xor "0001";
        else
            decode <= "0000";
            error := 2;
        end if;
        
        if(error = 2) then
            errors <= "10";    
        elsif(error = 1) then
            errors <= "01";
        else
            errors <= "00";
        end if;
    end process;
end Behavioral;
