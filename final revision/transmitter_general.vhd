----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2018 14:01:58
-- Design Name: 
-- Module Name: transmitter_general - Behavioral
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

entity transmitter_general is
    Port (raw: in std_logic_vector (3 downto 0);
    flag, clk, rst, ss2, network: in std_logic; --ss2 = slide switch 2
    hamming_errors: in std_logic_vector(7 downto 0);
    send_sig, done_sig: out std_logic;
    sig_out: out std_logic;
    test_sig: out std_logic_vector(69 downto 0);
    incs: out std_logic_vector(7 downto 0);
    byte: out std_logic_vector(7 downto 0);
    retransmit: in std_logic_vector(15 downto 0);
    r_flag: in std_logic; -- from receiver 
    bcd_count: out std_logic_vector(7 downto 0)     
    );
end transmitter_general;

architecture Behavioral of transmitter_general is
    component transmit_controller2 
        port(clk, reset, flag, done, ss2, r_flag : IN  std_logic;
        send, num1, num2: OUT std_logic
        );
    end component;

    component transmit_datapath     
    Port (raw: in std_logic_vector (3 downto 0);
        clk, rst: in std_logic;
        ss2: in std_logic; -- to toggle for hex character sending
        flag: in std_logic; 
        network: in std_logic;
        hamming_errors: in std_logic_vector(7 downto 0);
        send, num1, num2: in std_logic; --from controller 
        sig_out: out std_logic;
        test_sig: out std_logic_vector(69 downto 0);
        done: out std_logic; -- to controller  
        incs_test: out std_logic_vector(7 downto 0);
        byte_test: out std_logic_vector(7 downto 0);
        retransmit: in std_logic_vector(15 downto 0);
        r_flag: in std_logic; -- from receiver     
        bcd_count: out std_logic_vector(7 downto 0)   
        );
    end component;    
    signal done, num1, num2, send: std_logic;
begin
    send_sig <= send;
    done_sig <= done;
    C1: transmit_datapath port map(raw, clk, rst, ss2, flag, network, hamming_errors,
            send, num1, num2, sig_out, test_sig, done, incs, byte, retransmit, r_flag,
            bcd_count);
    C2: transmit_controller2 port map(clk, rst, flag, done, ss2, r_flag, send, num1, num2);

end Behavioral;
