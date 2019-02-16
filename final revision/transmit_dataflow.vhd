----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2018 10:33:23
-- Design Name: 
-- Module Name: transmit_dataflow - Behavioral
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

entity transmit_dataflow is
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
end transmit_dataflow;

architecture Behavioral of transmit_dataflow is

component hamming_manchester_encoder 
Port (raw: in std_logic_vector(3 downto 0);
    hamming_test: out std_logic_vector(10 downto 0);
    hamming_errors: in std_logic_vector(7 downto 0);
    encode_out: out std_logic_vector(21 downto 0)
    );
end component;

signal temp_out: std_logic_vector(21 downto 0);
signal encode_out: std_logic_vector(21 downto 0);
signal counter: integer range 0 to 31 := 0;
signal hamming_out: std_logic_vector(10 downto 0);
signal stop: std_logic := '0';

begin
    C1: hamming_manchester_encoder port map(raw, hamming_out, hamming_errors, temp_out);
    
    test_sig <= encode_out;
    hamming_test <= hamming_out;
    encode_out <= temp_out;
    
    process(clk, rst)
    begin
        if rst = '1' then
            done <= '0';
            counter <= 0;
            sig_out <= '0';
        elsif rising_edge(clk) then
            --stores in the send buffer
            if(send = '1' and counter = 0) then
                counter <= counter + 1;        
            --the cycle after stored in the send buffer
            elsif(send = '1' and stop = '0' and counter /= 0) then
                done <= '0';
                sig_out <= encode_out(22 - counter);
                counter <= counter + 1;
                
                if(counter = 22) then
                    done <= '1';
                    counter <= 0;
                    stop <= '1'; --forces a stop to sending before send is 0 again
                end if;
            end if;
            --the cycle after send is set to 0 force stop no longer
            --required
            if(send = '0') then
                stop <= '0';
            end if;
        end if;
    end process;
end Behavioral;
