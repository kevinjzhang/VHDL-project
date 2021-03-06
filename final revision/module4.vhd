----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2018 13:52:53
-- Design Name: 
-- Module Name: module4 - Behavioral
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

entity module4 is
Port (rx_in: in std_logic;
    clk, rst: in std_logic;
    read_sig, done_sig: out std_logic; --from controller
    decode_out: out std_logic_vector(3 downto 0);
    errors: out std_logic_vector(1 downto 0);
    manchester_test: out std_logic_vector(7 downto 0) 
    );
end module4;

architecture Behavioral of module4 is
    component receive_dataflow 
    Port (rx_in: in std_logic;
        clk, rst: in std_logic;
        read: in std_logic; --from controller
        decode_out: out std_logic_vector(3 downto 0);
        errors: out std_logic_vector(1 downto 0);
        done: inout std_logic; -- to controller and enable
        manchester_test: out std_logic_vector(7 downto 0) 
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
    C1: receive_dataflow port map(rx_in, clk, rst, read, decode_out, errors, done, manchester_test);
    C2: receive_controller port map(rx_in, done, clk, rst, read);
    
    read_sig <= read;
    done_sig <= done;

end Behavioral;
