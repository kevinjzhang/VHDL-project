----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.10.2018 20:12:43
-- Design Name: 
-- Module Name: receiver_general - Behavioral
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

entity receiver_general is
    Port (rx_in: in std_logic;
        clk, rst: in std_logic;
        decode_out: inout std_logic_vector(7 downto 0);
        bcd_errors: out std_logic_vector(7 downto 0);
        network, ring: in std_logic;
        read_sig, done_sig: out std_logic; 
        incs: in std_logic_vector(7 downto 0);
        retransmit: out std_logic_vector(15 downto 0);
        r_flag: inout std_logic; --flag to retransmit
        bcd_count, incs_test: out std_logic_vector(7 downto 0)
    );
end receiver_general;

architecture Behavioral of receiver_general is
    component receiver_datapath
    Port (rx_in: in std_logic;
        clk, rst: in std_logic;
        read: in std_logic; --from controller
        decode_out: inout std_logic_vector(7 downto 0);
        bcd_errors: out std_logic_vector(7 downto 0);
        done: inout std_logic; -- to controller and enable
        network, ring: in std_logic;
        incs: in std_logic_vector(7 downto 0);
        retransmit: out std_logic_vector(15 downto 0);
        r_flag: inout std_logic; --flag to retransmit
        bcd_count, incs_test: out std_logic_vector(7 downto 0)
        );
    end component;
    
    component receive_controller 
    Port ( rx_in: in std_logic;
        done, clk, rst: in std_logic; --clk must be at the rate of receiving
        read: out std_logic
        );
    end component;    
    
    signal read, done: std_logic;  
begin   
    C1: receiver_datapath port map(rx_in, clk, rst, read, decode_out, bcd_errors, done,
            network, ring, incs, retransmit, r_flag, bcd_count, incs_test);
    C2: receive_controller port map(rx_in, done, clk, rst, read);
    
    read_sig <= read;
    done_sig <= done;   

end Behavioral;
