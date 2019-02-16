----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2018 15:09:33
-- Design Name: 
-- Module Name: keypad - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keypad is
    Port (clk : in  STD_LOGIC;
        flag: out std_logic;
        Row : in  STD_LOGIC_VECTOR (3 downto 0);
        Col : out  STD_LOGIC_VECTOR (3 downto 0);
        DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0)       
        );
end keypad;

architecture Behavioral of keypad is
--approx 700hz so 1.5ms to update
signal sclk :STD_LOGIC_VECTOR(12 downto 0) := "0000000000000";
begin
	process(clk)
    begin 
    if clk'event and clk = '1' then
        -- 1ms
        if sclk = "0000000000000" then 
            --C1
            Col<= "0111";
            sclk <= sclk+1;
        -- check row pins
        elsif sclk = "0001000000000" then    
            --R1
            if Row = "0111" then
                DecodeOut <= "0001";    --1
            --R2
            elsif Row = "1011" then
                DecodeOut <= "0100"; --4
            --R3
            elsif Row = "1101" then
                DecodeOut <= "0111"; --7
            --R4
            elsif Row = "1110" then
                DecodeOut <= "0000"; --0
            end if;
            sclk <= sclk+1;
        -- 2ms
        elsif sclk = "0010000000000" then    
            --C2
            Col<= "1011";
            sclk <= sclk+1;
        -- check row pins
        elsif sclk = "0011000000000" then    
            --R1
            if Row = "0111" then        
                DecodeOut <= "0010"; --2
            --R2
            elsif Row = "1011" then
                DecodeOut <= "0101"; --5
            --R3
            elsif Row = "1101" then
                DecodeOut <= "1000"; --8
            --R4
            elsif Row = "1110" then
                DecodeOut <= "1111"; --F
            end if;
            sclk <= sclk+1;    
        --3ms
        elsif sclk = "0100000000000" then 
            --C3
            Col<= "1101";
            sclk <= sclk+1;
        -- check row pins
        elsif sclk = "0101000000000" then 
            --R1
            if Row = "0111" then
                DecodeOut <= "0011"; --3    
            --R2
            elsif Row = "1011" then
                DecodeOut <= "0110"; --6
            --R3
            elsif Row = "1101" then
                DecodeOut <= "1001"; --9
            --R4
            elsif Row = "1110" then
                DecodeOut <= "1110"; --E
            end if;
            sclk <= sclk+1;
        --4ms
        elsif sclk = "0110000000000" then             
            --C4
            Col<= "1110";
            sclk <= sclk+1;
        -- check row pins
        elsif sclk = "0111000000000" then 
            --R1
            if Row = "0111" then
                DecodeOut <= "1010"; --A
            --R2
            elsif Row = "1011" then
                DecodeOut <= "1011"; --B
            --R3
            elsif Row = "1101" then
                DecodeOut <= "1100"; --C
            --R4
            elsif Row = "1110" then
                DecodeOut <= "1101"; --D
            end if;
            sclk <= sclk+1;
            
        -- 72 ticks at 100mhz => 1mhz 
        elsif sclk = "1000000000000" then             
        --Check for nothing pressed
            Col<= "0000";
            sclk <= sclk+1;
        elsif sclk = "1001000000000" then
            if Row = "1111" then
                flag <= '0';
            else 
                flag <= '1';
            end if;
            sclk <= "0000000000000";            
        else
            sclk <= sclk+1;    
        end if;
    end if;
end process;

end Behavioral;
