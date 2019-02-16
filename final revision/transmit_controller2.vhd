----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2018 13:55:23
-- Design Name: 
-- Module Name: transmit_controller2 - Behavioral
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

entity transmit_controller2 is
	port(clk, reset, flag, done, ss2, r_flag : IN  std_logic;
    send, num1, num2: OUT std_logic
    );
end transmit_controller2;

architecture Behavioral of transmit_controller2 is
    type state_type is (s1, s2, s3, s4);
    signal state : state_type;
    signal state2 : state_type; --for changing INCS
begin
process(clk, reset)
begin
    if (reset = '1') then
        state <= s1;
        send <= '0';
    elsif rising_edge(clk) then
        if(r_flag = '1') then
            send <= '1';
            num1 <= '0';
            num2 <= '0';     
        elsif(ss2 = '0') then                           
            case state is
                when s1 =>               
                    if(flag = '1') then
                        state <= s2;                      
                    else
                        state <= s1;                   
                    end if; 
                    send <= '0';
                    num1 <= '0';
                    num2 <= '0';                
                when s2 =>
                    if(flag = '1') then
                        state <= s2;                    
                    else
                        state <= s3;                     
                    end if;       
                    send <= '0';
                    num1 <= '1';
                    num2 <= '0';                                            
                when s3 =>
                    if(flag = '1') then
                        state <= s4;  
                        num2 <= '1';                   
                    else
                        state <= s3;
                        num2 <= '0';                   
                    end if;
                    send <= '0'; 
                    num1 <= '0';                    
                when s4 =>
                    if(done = '1' and flag = '0') then
                        state <= s1;                    
                    else
                        state <= s4;                    
                    end if;    
                    send <= '1';
                    num1 <= '0';
                    num2 <= '0';              
            end case;
        else
            case state2 is
            when s1 =>
                if(flag = '1') then
                    state2 <= s2;
                else
                    state2 <= s1;                  
                end if; 
                send <= '0';
                num1 <= '0';
                num2 <= '0';               
            when s2 =>
                if(flag = '1') then
                    state2 <= s2;                    
                else
                    state2 <= s3;                    
                end if;   
                send <= '0';
                num1 <= '1';
                num2 <= '0';                                          
            when s3 =>
                if(flag = '1') then
                    state2 <= s4;                      
                else
                    state2 <= s3;                   
                end if;
                send <= '0';
                num1 <= '0';
                num2 <= '0';                 
            when s4 =>
                if(flag = '0') then
                    state2 <= s1;                    
                else
                    state2 <= s4;                    
                end if;
                send <= '0';
                num1 <= '0';
                num2 <= '1';                                  
            end case;       
        end if;
    end if;
end process;


end Behavioral;
