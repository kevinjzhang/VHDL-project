----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2018 11:13:53
-- Design Name: 
-- Module Name: test_module7 - Behavioral
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

entity test_module7 is
--  Port ( );
end test_module7;

architecture Behavioral of test_module7 is
component bus_interface 
Port (flag: in std_logic; --used for rx    
    read_req_test, dataRdy_test: out std_logic; 
    ack1_test: out std_logic;
    ack2_test: out std_logic;  
    data_test: out std_logic_vector(31 downto 0); --dataOut, should be mostly 0
    rst, clk: in std_logic;
    addr: in std_logic_vector(17 downto 0);
    modData: in std_logic_vector(191 downto 0); --6 times 32 - 1
    modDataO: out std_logic_vector(191 downto 0); --6 times 32 - 1
    EN_test1: out std_logic_vector(5 downto 0);
    EN_test2: out std_logic_vector(5 downto 0)    
);
end component;
    signal flag, readReq, dataRdy, acki, acko, rst: std_logic;
    signal modData, modDataO: std_logic_vector(191 downto 0);
    signal addr: std_logic_vector(17 downto 0); 
    signal clk: std_logic := '0';
    signal data: std_logic_vector(31 downto 0);
    signal EN_tx, EN_rx:  std_logic_vector(5 downto 0);
begin

addr(17 downto 15) <= "000";
addr(14 downto 12) <= "001";
addr(11 downto 9) <= "010";
addr(8 downto 6) <= "011";
addr(5 downto 0) <= "100101";

modData(127 downto 0) <= (others => '1');
modData(191 downto 160) <= x"12345678";
modData(159 downto 128) <= x"87654321";
uut: bus_interface port map(flag, readReq, dataRdy, acki, acko, data, rst, clk, addr, modData, modDataO, EN_rx, EN_tx);

--need approx 100 clock cycles per complete update
clk <= not clk after 10ns;

process
begin
    rst <= '1';
    wait for 10ns;
    rst <= '0';
    
    flag <= '1';
    wait for 4000ns;
       
end process;

end Behavioral;
