----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2018 10:50:53
-- Design Name: 
-- Module Name: bus_tx - Behavioral
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

entity bus_tx is
Port (dataRdy: out std_logic;
    readReq: in std_logic;
    acki: in std_logic;
    acko: out std_logic;
    rst, clk: in std_logic;
    dataIn: in std_logic_vector(31 downto 0); --data prepared
    dataOut: out std_logic_vector(31 downto 0); --data sent
    EN: in std_logic 
);
end bus_tx;

architecture Behavioral of bus_tx is
type state_type is (s1, s2, s3, s4, s5);
signal state : state_type;

begin
process(clk, rst, EN)
begin
    if (rst = '1' or EN = '0') then
        state <= s1;
        dataOut <= (others => '0');
        dataRdy <= '0';
        acko <= '0';  
    elsif rising_edge(clk) then
        case state is
            when s1 =>
                if(readReq = '1') then
                    state <= s2;
                else
                    state <= s1;
                end if;
                dataRdy <= '0';
                acko <= '0';                
            when s2 => --send the address
                if(readReq = '0') then
                    state <= s3;
                else
                    state <= s2;
                end if;
                acko <= '1';
                dataRdy <= '0';           
            when s3 =>
                if(acki = '1') then
                    state <= s4;
                else
                    state <= s3;
                end if;
                dataRdy <= '1';
                acko <= '0';  
                dataOut <= dataIn;         
            when s4 =>
                if(acki = '0') then
                    state <= s5;
                else
                    state <= s4;
                end if; 
                dataRdy <= '0';
                acko <= '0';           
            when s5 => --read the data
                state <= s1;
                dataRdy <= '0';
                acko <= '0';
                dataOut <= (others => '0');  
        end case;          
    end if;    
end process;


end Behavioral;
