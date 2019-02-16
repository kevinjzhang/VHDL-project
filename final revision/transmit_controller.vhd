----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2018 10:36:28
-- Design Name: 
-- Module Name: transmit_controller - Behavioral
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

entity transmit_controller is
	port(clk, reset, flag, done : IN  std_logic;
        send : OUT std_logic
        );
end transmit_controller;

architecture Behavioral of transmit_controller is
    type state_type is (s1, s2, s3);
	signal state : state_type;
begin
    process(clk, reset)
    begin
        if (reset = '1') then
            state <= s1;
            send <= '0';
        elsif rising_edge(clk) then
            case state is
                when s1 =>
                    if(flag = '1') then
                        state <= s2;
                    else
                        state <= s1;
                    end if;
                    send <= '0';
                when s2 =>
                    if(flag = '1') then
                        state <= s2;
                    else
                        state <= s3;
                    end if;
                    send <= '1';               
                when s3 =>
                    if(done = '1') then
                        state <= s1;
                    else
                        state <= s3;
                    end if;
                    send <= '1';                
            end case;
        end if;
    end process;

end Behavioral;
