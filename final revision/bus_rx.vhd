----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2018 10:30:02
-- Design Name: 
-- Module Name: bus_rx - Behavioral
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

entity bus_rx is
Port (flag, dataRdy: in std_logic;
    readReq: out std_logic;
    acko: in std_logic;
    acki: out std_logic;
    rst, clk: in std_logic;
    dataIn: in std_logic_vector(31 downto 0); --dataIn, should be mostly 0
    dataOut: out std_logic_vector(31 downto 0); --dataOut, should be mostly 0
    sel: out std_logic_vector(2 downto 0);
    addr: in std_logic_vector(2 downto 0);
    EN: in std_logic  
);
end bus_rx;

architecture Behavioral of bus_rx is
type state_type is (s1, s2, s3, s4, s5, s6);
signal state : state_type;

begin

process(clk, rst, EN)
begin
    if(EN = '0') then
        sel <= (others => '0');
    else
        sel <= addr;
    end if;

    if (rst = '1' or EN = '0') then
        state <= s1;    
        if (rst = '1') then    
            dataOut <= (others => '0');
        end if;
        acki <= '0';
        readReq <= '0';
    elsif rising_edge(clk) then
        case state is
            when s1 =>
                if(flag = '1') then
                    state <= s2;
                else
                    state <= s1;
                end if;
                readReq <= '0';                
            when s2 => --send the address
                if(acko = '1') then
                    state <= s3;
                else
                    state <= s2;
                end if;
                readReq <= '1';           
            when s3 =>
                if(acko = '0') then
                    state <= s4;
                else
                    state <= s3;
                end if;
                readReq <= '0';
            when s4 =>
                if(dataRdy = '1') then
                    state <= s5;
                else
                    state <= s4;
                end if;       
                readReq <= '0';     
            when s5 => --read the data
                if(dataRdy = '0') then
                    state <= s6;
                else
                    state <= s5;
                end if;
                acki <= '1';
                readReq <= '0';
                dataOut <= dataIn;
            when s6 =>
                state <= s1;
                acki <= '0';
                readReq <= '0';               
        end case;          
    end if;    
end process;

end Behavioral;
