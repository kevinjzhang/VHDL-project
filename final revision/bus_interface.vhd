----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2018 11:37:49
-- Design Name: 
-- Module Name: bus_interface - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bus_interface is
Port (flag: in std_logic; --used for rx    
    read_req_test, dataRdy_test: out std_logic; 
    ack1_test: out std_logic;
    ack2_test: out std_logic;  
    data_test: out std_logic_vector(31 downto 0); --dataOut, should be mostly 0
    rst, clk: in std_logic;
    addr: in std_logic_vector(17 downto 0); -- 6 times 3 - 1
    modData: in std_logic_vector(191 downto 0); --6 times 32 - 1
    modDataO: out std_logic_vector(191 downto 0); --6 times 32 - 1
    EN_test1: out std_logic_vector(5 downto 0);
    EN_test2: out std_logic_vector(5 downto 0)
);
end bus_interface;

architecture Behavioral of bus_interface is
signal read_req, read_req1, read_req2, read_req3, read_req4, read_req5, read_req6: std_logic; 
signal dataRdy, dataRdy1, dataRdy2, dataRdy3, dataRdy4, dataRdy5, dataRdy6: std_logic;
signal acki, acki1, acki2, acki3, acki4, acki5, acki6: std_logic;
signal acko, acko1, acko2, acko3, acko4, acko5, acko6: std_logic;
signal sel, sel1, sel2, sel3, sel4, sel5, sel6: std_logic_vector(2 downto 0);
signal data, data1, data2, data3, data4, data5, data6: std_logic_vector(31 downto 0); 

signal sclk: std_logic_vector(11 downto 0) := x"000";

signal EN_rx: std_logic_vector(5 downto 0) := "000000"; --6 modules
signal EN_tx: std_logic_vector(5 downto 0);

   
component bus_rx
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
end component;

component bus_tx is
Port (dataRdy: out std_logic;
    readReq: in std_logic;
    acki: in std_logic;
    acko: out std_logic;
    rst, clk: in std_logic;
    dataIn: in std_logic_vector(31 downto 0); --data prepared
    dataOut: out std_logic_vector(31 downto 0); --data sent
    EN: in std_logic 
);
end component;

begin
    --module 1
    C1: bus_rx port map(flag, dataRdy, read_req1, acko, acki1, rst, clk, data, modDataO(191 downto 160), sel1, addr(17 downto 15), EN_rx(0));
    C2: bus_tx port map(dataRdy1, read_req, acki, acko1, rst, clk, modData(191 downto 160), data1, EN_tx(0));
    --module 2
    C3: bus_rx port map(flag, dataRdy, read_req2, acko, acki2, rst, clk, data ,modDataO(159 downto 128), sel2, addr(14 downto 12), EN_rx(1));
    C4: bus_tx port map(dataRdy2, read_req, acki, acko2, rst, clk, modData(159 downto 128), data2, EN_tx(1));
    --module 3
    C5: bus_rx port map(flag, dataRdy, read_req3, acko, acki3, rst, clk, data, modDataO(127 downto 96), sel3, addr(11 downto 9), EN_rx(2));
    C6: bus_tx port map(dataRdy3, read_req, acki, acko3, rst, clk, modData(127 downto 96), data3, EN_tx(2));
    --module 4
    C7: bus_rx port map(flag, dataRdy, read_req4, acko, acki4, rst, clk, data, modDataO(95 downto 64), sel4, addr(8 downto 6), EN_rx(3));
    C8: bus_tx port map(dataRdy4, read_req, acki, acko4, rst, clk, modData(95 downto 64), data4, EN_tx(3));
    --module 5
    C9: bus_rx port map(flag, dataRdy, read_req5, acko, acki5, rst, clk, data, modDataO(63 downto 32), sel5, addr(5 downto 3), EN_rx(4));
    C10: bus_tx port map(dataRdy5, read_req, acki, acko5, rst, clk, modData(63 downto 32), data5, EN_tx(4));
    --module 6
    C11: bus_rx port map(flag, dataRdy, read_req6, acko, acki6, rst, clk, data, modDataO(31 downto 0), sel6, addr(2 downto 0), EN_rx(5));
    C12: bus_tx port map(dataRdy6, read_req, acki, acko6, rst, clk, modData(31 downto 0), data6, EN_tx(5));                
    
    data <= data1 or data2 or data3 or data4 or data5 or data6;
    read_req <= read_req1 or read_req2 or read_req3 or read_req4 or read_req5 or read_req6;
    dataRdy <= dataRdy1 or dataRdy2 or dataRdy3 or dataRdy4 or dataRdy5 or dataRdy6;
    acki <= acki1 or acki2 or acki3 or acki4 or acki5 or acki6;
    acko <= acko1 or acko2 or acko3 or acko4 or acko5 or acko6;
    sel <= sel1 or sel2 or sel3 or sel4 or sel5 or sel6; 
    
    read_req_test <= read_req;
    dataRdy_test <= dataRdy;
    ack1_test <= acki;
    ack2_test <= acko;
    EN_test1 <= EN_rx;
    EN_test2 <= EN_tx;
    data_test <= data;
    
    EN_tx <= "000001" when sel = "000" else
        "000010" when sel = "001" else
        "000100" when sel = "010" else
        "001000" when sel = "011" else
        "010000" when sel = "100" else
        "100000" when sel = "101" else
        "000000"; --When sel is other values, gets zeros
    
    process (clk, rst)
    begin
        if(rst = '1') then
            sclk <= x"000";
            EN_rx <= "000001";
        elsif(rising_edge(clk)) then
            sclk <= sclk + 1;
            if sclk = x"000" then
                EN_rx <= "000001";
            elsif sclk = x"010" then
                EN_rx <= "000010";                
            elsif sclk = x"020" then
                EN_rx <= "000100";
            elsif sclk = x"030" then
                EN_rx <= "001000";
            elsif sclk = x"040" then
                EN_rx <= "010000";   
            elsif sclk = x"050" then
                EN_rx <= "100000"; 
            elsif sclk = x"060" then 
                sclk <= x"000";                                               
            end if;
        end if;
    end process;

end Behavioral;
