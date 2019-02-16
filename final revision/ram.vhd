----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2018 08:08:49
-- Design Name: 
-- Module Name: ram - Behavioral
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
USE ieee.numeric_std.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram is
Port (address: in std_logic_vector(4 downto 0); --32 times 1-byte
    tx_addr: in std_logic_vector(4 downto 0);
    d_in: in std_logic_vector(7 downto 0);
    we, re: in std_logic;
    clk, rst: in std_logic;
    d_out: out std_logic_vector(15 downto 0)
    );
end ram;

architecture Behavioral of ram is
    type RAM is array (0 to 31) of std_logic_vector(7 downto 0); --64 times 4 bit
    signal storage: RAM;
            
begin
    process (clk, rst)
        variable index1, index2: integer range 0 to 31;
        
        begin
            if rst = '1' then
                storage <= (others => x"00");
            elsif rising_edge(clk) then
                
                index1 := to_integer(unsigned(address)); 
                storage(index1) <= d_in;
                    
                index2 := to_integer(unsigned(tx_addr)); 
                d_out(7 downto 0) <= storage(index2);
                d_out(15 downto 8) <= x"00";    
            end if;
        end process;
end Behavioral;
