----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2018 13:52:26
-- Design Name: 
-- Module Name: receive_controller - Behavioral
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

entity receive_controller is
Port ( rx_in: in std_logic;
    done, clk, rst: in std_logic; --clk must be at the rate of receiving
    read: out std_logic
    );
end receive_controller;

architecture Behavioral of receive_controller is
    type state_type is (s0, s1, s2, s3, s4);
    signal state : state_type;
begin
    process(clk, rst)
    begin
        if (rst = '1') then
            state <= s0;
            read <= '0';
        elsif rising_edge(clk) then
            case state is
                when s0 => --rx_in should mostly be in s1
                    if rx_in = '0' then
                        state <= s1;
                        read <= '0';
                    else
                        state <= s0;
                        read <= '0';
                    end if;             
                when s1 =>
                    if rx_in = '1' then
                        state <= s2;
                        read <= '0';
                    else
                        state <= s1;
                        read <= '0';
                    end if;    
                when s2 =>
                    if rx_in = '1' then
                        state <= s0;
                        read <= '0';    
                    else
                        state <= s3;
                        read <= '0';
                    end if;                
                when s3 =>
                    if rx_in = '1' then
                        state <= s4;
                        read <= '1'; --at next clock cycle ready to read
                    else
                        state <= s1;
                        read <= '0';
                    end if;                
                when s4 =>
                    if done = '1' then
                        state <= s0;
                        read <= '0'; --at 2 clock cycles after
                    else
                        state <= s4;
                        read <= '1';
                    end if;                 
            end case;
        end if;
    end process;

end Behavioral;
