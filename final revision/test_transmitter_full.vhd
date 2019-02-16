----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2018 14:22:21
-- Design Name: 
-- Module Name: test_transmitter_full - Behavioral
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

entity test_transmitter_full is
--  Port ( );
end test_transmitter_full;

architecture Behavioral of test_transmitter_full is
    component transmitter_general 
        Port (raw: in std_logic_vector (3 downto 0);
        flag, clk, rst, ss2, network: in std_logic; --ss2 = slide switch 2
        hamming_errors: in std_logic_vector(7 downto 0);
        send_sig, done_sig: out std_logic;
        sig_out: out std_logic;
        test_sig: out std_logic_vector(69 downto 0);
        incs: out std_logic_vector(7 downto 0);
        byte: out std_logic_vector(7 downto 0);
        retransmit: in std_logic_vector(15 downto 0);
        r_flag: in std_logic; -- from receiver;
        bcd_count: out std_logic_vector(7 downto 0)           
        );
    end component;
    signal raw: std_logic_vector (3 downto 0);
    signal flag, send_sig, done_sig, sig_out, ss2, network, r_flag: std_logic;
    signal clk, rst: std_logic := '0';
    signal hamming_errors: std_logic_vector (7 downto 0);
    signal test_sig: std_logic_vector(69 downto 0);
    signal incs, byte: std_logic_vector (7 downto 0);  
    signal retransmit: std_logic_vector(15 downto 0);
    signal bcd_count: std_logic_vector(7 downto 0);
begin
    uut: transmitter_general port map(raw, flag, clk, rst, ss2, network, hamming_errors,
            send_sig, done_sig, sig_out, test_sig, incs, byte, retransmit, r_flag, bcd_count);
            
    clk <= not clk after 5ps;
    process
    variable sig1: std_logic_vector(71 downto 0) := x"166a559a655555a696";
    variable sig2: std_logic_vector(39 downto 0) := x"16965969a6";
    begin
        r_flag <= '0';
        retransmit <= x"8526";
        ss2 <= '0';
        network <= '1';
        
        rst <= '1';
        wait for 10ns;
        rst <= '0';
        wait for 10ns; 
        
        hamming_errors <= x"00";
        raw <= "1111";
        flag <= '1';  
        wait for 40ns;
        flag <= '0';  
        wait for 40ns;   
        raw <= "0011";
        flag <= '1'; 
        wait for 20ns;
        flag <= '0'; 
        wait for 10ns;
        --130ns checks 125ns send
        for I in 0 to 69 loop
            assert (sig_out = sig1(69 - I)) report "sent wrong" severity error;
            wait for 10ns; 
        end loop;
        wait for 40ns; 
        
        network <= '0';
        raw <= "0110";
        flag <= '1';  
        wait for 40ns;
        flag <= '0';  
        wait for 40ns;   
        raw <= "1001";
        flag <= '1'; 
        wait for 20ns;
        flag <= '0'; 
                
        for I in 0 to 37 loop
            assert (sig_out = sig2(37 - I)) report "sent wrong" severity error;
            wait for 10ns; 
        end loop;  
        
        network <= '1';
        hamming_errors <= x"80"; 
        raw <= "0110";
        flag <= '1';  
        wait for 40ns;
        flag <= '0';  
        wait for 40ns;   
        raw <= "1001";
        flag <= '1'; 
        wait for 20ns;
        flag <= '0'; 
        wait for 1000ns;              
        
        ss2 <= '0';
        raw <= "0110";
        flag <= '1';  
        wait for 100ns;
        flag <= '0';  
        wait for 40ns;  
         
        raw <= "1101";
        flag <= '1';   
        wait for 80ns; 
        flag <= '0';
        wait for 20ns;
         
        raw <= "0101";
        flag <= '1';   
        wait for 50ns; 
        flag <= '0';
        wait for 50ns;
        
        raw <= "0111";
        flag <= '1';   
        wait for 50ns; 
        flag <= '0';
        wait for 500ns;        
        
        ss2 <= '1';
        r_flag <= '1';
        wait for 500ns;     
        
        r_flag <= '0';
        wait for 10ns;
        
        r_flag <= '1';
        wait for 500ns;                              
    end process;
end Behavioral;
