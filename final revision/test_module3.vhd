----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2018 11:37:45
-- Design Name: 
-- Module Name: test_module3 - Behavioral
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

entity test_module3 is
--  Port ( );
end test_module3;

architecture Behavioral of test_module3 is
    component module3 
    Port (raw: in std_logic_vector (3 downto 0);
        flag, clk, rst: in std_logic;
        hamming_errors: in std_logic_vector(7 downto 0);
        send_sig, done_sig: out std_logic;
        sig_out: out std_logic;
        test_sig: out std_logic_vector(21 downto 0);
        hamming_test: out std_logic_vector(10 downto 0)    
        );
    end component;
    signal raw: std_logic_vector (3 downto 0);
    signal flag, send_sig, done_sig, sig_out: std_logic;
    signal clk, rst: std_logic := '0';
    signal hamming_errors: std_logic_vector (7 downto 0);
    signal test_sig: std_logic_vector(21 downto 0);
    signal hamming_test: std_logic_vector(10 downto 0);
    signal sig: std_logic_vector(23 downto 0) := x"16aaaa";
begin
    uut: module3 port map(raw, flag, clk, rst, hamming_errors, send_sig, done_sig, sig_out, test_sig, hamming_test);

    clk <= not clk after 10ns;

    input_gen: process
    variable sig1: std_logic_vector(23 downto 0) := x"16aaaa";
    variable sig2: std_logic_vector(23 downto 0) := x"1656a6";
    variable sig3: std_logic_vector(23 downto 0) := x"15a696";
    variable sig4: std_logic_vector(23 downto 0) := x"166956";
    variable sig5: std_logic_vector(23 downto 0) := x"15555a";
    begin
        rst <= '1';
        wait for 10ns;
        rst <= '0';
        wait for 40ns;
        
        hamming_errors <= x"00";
        raw <= "0000";
        flag <= '1';
        wait for 40ns;
        flag <= '0';
        wait for 40ns;
        for I in 0 to 21 loop
            wait for 5ns;
            assert (sig_out = sig1(21 - I)) report "sent wrong" severity error;
            wait for 15ns; 
        end loop;
        assert (hamming_test = "11000000000") report "0-hamming encode" severity error;
        
        raw <= "0001";
        flag <= '1';
        wait for 40ns;
        flag <= '0';
        wait for 20ns;
        for I in 0 to 21 loop
            wait for 5ns;
            assert (sig_out = sig2(21 - I)) report "sent wrong" severity error;
            wait for 15ns; 
        end loop;
        assert (hamming_test = "11011100010") report "1-hamming encode" severity error;
        
        raw <= "0011";
        flag <= '1';
        wait for 40ns;
        flag <= '0';
        wait for 20ns;
        for I in 0 to 21 loop           
            wait for 5ns;
            assert (sig_out = sig3(21 - I)) report "sent wrong" severity error;
            wait for 15ns;  
        end loop;
        assert (hamming_test = "11100100110") report "2-hamming encode" severity error;
        
        raw <= "0111";
        hamming_errors <= x"08";
        flag <= '1';
        wait for 40ns;
        flag <= '0';
        wait for 20ns;
        for I in 0 to 21 loop
            wait for 5ns;
            assert (sig_out = sig4(21 - I)) report "sent wrong" severity error;
            wait for 15ns; 
        end loop;
        assert (hamming_test = "11010011110") report "3-error mask" severity error;
        
        raw <= "1111";
        hamming_errors <= x"01";
        flag <= '1';
        wait for 40ns;
        flag <= '0';
        wait for 20ns;
        for I in 0 to 21 loop
            wait for 5ns;
            assert (sig_out = sig5(21 - I)) report "sent wrong" severity error;
            wait for 15ns; 
        end loop;
        assert (hamming_test = "11111111100") report "4-error mask" severity error;      
    end process;
end Behavioral;
