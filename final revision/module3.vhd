----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2018 10:38:10
-- Design Name: 
-- Module Name: module3 - Behavioral
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

entity module3 is
Port (raw: in std_logic_vector (3 downto 0);
    flag, clk, rst: in std_logic;
    hamming_errors: in std_logic_vector(7 downto 0);
    send_sig, done_sig: out std_logic;
    sig_out: out std_logic;
    test_sig: out std_logic_vector(21 downto 0);
    hamming_test: out std_logic_vector(10 downto 0)    
    );
end module3;

architecture Behavioral of module3 is
    component transmit_controller is
        port(clk, reset, flag, done : IN  std_logic;
            send : OUT std_logic
            );
    end component;
    
    component transmit_dataflow 
    Port (raw: in std_logic_vector (3 downto 0);
        clk, rst: in std_logic;
        flag: in std_logic;
        hamming_errors: in std_logic_vector(7 downto 0);
        send: in std_logic; --from controller 
        sig_out: out std_logic;
        done: out std_logic; -- to controller  
        test_sig: out std_logic_vector(21 downto 0);
        hamming_test: out std_logic_vector(10 downto 0)
        );
    end component;

signal send: std_logic; --from controller 
signal done: std_logic; --to controller 

begin
    C1: transmit_dataflow port map(raw, clk, rst, flag, hamming_errors, send, sig_out, done, test_sig, hamming_test);
    C2: transmit_controller port map(clk, rst, flag, done, send);
    
    send_sig <= send;
    done_sig <= done;
end Behavioral;
