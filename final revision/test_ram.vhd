----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2018 11:23:48
-- Design Name: 
-- Module Name: test_ram - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_ram is
--  Port ( );
end test_ram;

architecture Behavioral of test_ram is


component ram 
Port (address: in std_logic_vector(4 downto 0); --32 times 1-byte
    tx_addr: in std_logic_vector(4 downto 0);
    d_in: in std_logic_vector(7 downto 0);
    we, re: in std_logic;
    clk, rst: in std_logic;
    d_out: out std_logic_vector(15 downto 0)
    );
end component;

    signal we, re, clk, rst: std_logic := '0';
    signal tx_addr, address: std_logic_vector(4 downto 0);
    signal d_in: std_logic_vector(7 downto 0);
    signal d_out: std_logic_vector(15 downto 0);
begin
    uut: ram port map(address, tx_addr, d_in, we, re, clk, rst, d_out);

    clk <= not clk after 100 ps;
    process
    begin
        rst <= '1';
        wait for 10ns;
        rst <= '0';
        we <= '1';
        re <= '1';
        d_in <= x"12";
        tx_addr <= "00000";
        address <= "00000";
        wait for 10ns;
        for I in 0 to 31 loop
            address <= std_logic_vector(unsigned(address) + 1);
            d_in <= std_logic_vector(unsigned(d_in) + 1);
            wait for 10ns;
        end loop;
        
        for I in 0 to 31 loop
            tx_addr <= std_logic_vector(unsigned(tx_addr) + 1);
            wait for 10ns;
        end loop;
    
    end process;

end Behavioral;
