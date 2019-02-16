----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2018 14:44:26
-- Design Name: 
-- Module Name: test_module4 - Behavioral
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

entity test_module4 is
--  Port ( );
end test_module4;

architecture Behavioral of test_module4 is
component module4 
Port (rx_in: in std_logic;
    clk, rst: in std_logic;
    read_sig, done_sig: out std_logic; --from controller
    decode_out: out std_logic_vector(3 downto 0);
    errors: out std_logic_vector(1 downto 0);
    manchester_test: out std_logic_vector(7 downto 0) 
    );
end component;
    signal rx_in, clk, rst, read_sig, done_sig: std_logic := '0';
    signal decode_out: std_logic_vector(3 downto 0);
    signal errors: std_logic_vector(1 downto 0);
    signal manchester_test: std_logic_vector(7 downto 0);
   
begin
    uut: module4 port map(rx_in, clk, rst, read_sig, done_sig, decode_out, errors, manchester_test);
    
    clk <= not clk after 10ns;
    
    process
    variable input1: std_logic_vector(23 downto 0) := x"16aaaa";
    variable input2: std_logic_vector(23 downto 0) := x"1656a6";
    variable input3: std_logic_vector(23 downto 0) := x"15a696";
    variable input4: std_logic_vector(23 downto 0) := x"166956";
    variable input5: std_logic_vector(23 downto 0) := x"15555a";
    variable input6: std_logic_vector(21 downto 0) := "0101101001100101011001";
    begin
        rst <= '1';
        wait for 10ns;
        rst <= '0';
        
        for I in 0 to 21 loop
            rx_in <= input1(21 - I);
            wait for 20ns;
        end loop;
        wait for 40ns;
        assert (errors = "00") report "1-Wrong error count" severity error;
        assert (decode_out = "0000") report "1-Wrong output" severity error;
        assert (manchester_test = "00000000") report "1-hamming encode" severity error;
        
        for I in 0 to 21 loop
            rx_in <= input2(21 - I);
            wait for 20ns;
        end loop;
        wait for 40ns;
        assert (errors = "00") report "2-Wrong error count" severity error;
        assert (decode_out = "0001") report "2-Wrong output" severity error;
        assert (manchester_test = "01110001") report "2-hamming encode" severity error;
                
        for I in 0 to 21 loop
            rx_in <= input3(21 - I);
            wait for 20ns;
        end loop;
        wait for 40ns;
        assert (errors = "00") report "3-Wrong error count" severity error;
        assert (decode_out = "0011") report "3-Wrong output" severity error;
        assert (manchester_test = "10010011") report "3-hamming encode" severity error;
        
         for I in 0 to 21 loop
            rx_in <= input4(21 - I);
            wait for 20ns;
        end loop;
        wait for 40ns;
        assert (errors = "01") report "4-Wrong error count" severity error;
        assert (decode_out = "0111") report "4-Wrong output" severity error;       
        assert (manchester_test = "01001111") report "4-hamming encode" severity error;
        
        for I in 0 to 21 loop
            rx_in <= input5(21 - I);
            wait for 20ns;
        end loop;
        wait for 40ns;
        assert (errors = "01") report "5-Wrong error count" severity error;
        assert (decode_out = "1111") report "5-Wrong output" severity error;
        assert (manchester_test = "11111110") report "5-hamming encode" severity error; 
        
        for I in 0 to 21 loop
            rx_in <= input6(21 - I);
            wait for 20ns;
        end loop;
        wait for 40ns;
        assert (errors = "10") report "6-Wrong error count" severity error;                     
    end process;

end Behavioral;
