----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2018 13:52:00
-- Design Name: 
-- Module Name: receive_dataflow - Behavioral
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

entity receive_dataflow is
Port (rx_in: in std_logic;
    clk, rst: in std_logic;
    read: in std_logic; --from controller
    decode_out: out std_logic_vector(3 downto 0);
    errors: out std_logic_vector(1 downto 0);
    done: inout std_logic; -- to controller and enable
    manchester_test: out std_logic_vector(7 downto 0) 
    );
end receive_dataflow;

architecture Behavioral of receive_dataflow is
    component manchester_hamming_decoder 
    Port (EN: in std_logic;
        encode_in: in std_logic_vector(15 downto 0);
        decode_out: out std_logic_vector(3 downto 0);
        errors: out std_logic_vector(1 downto 0);
        manchester_test: out std_logic_vector(7 downto 0) 
    );
    end component;
signal EN: std_logic; -- enable, if not enabled decode_out reamains 0
signal encode_in: std_logic_vector(15 downto 0);
signal manchester: std_logic_vector(7 downto 0);
signal counter: integer range 0 to 31 := 0;
signal stop: std_logic := '0';

begin
    C1: manchester_hamming_decoder port map(EN, encode_in, decode_out, errors, manchester);
    manchester_test <= manchester;

    process(clk, rst)
    begin
        if rst = '1' then
            done <= '0';
            encode_in <= (others => '0');
            counter <= 0;
        elsif rising_edge(clk) then
            if read = '1' and stop <= '0' then
                EN <= '0';
                encode_in(15 - counter) <= rx_in;
                counter <= counter + 1;
                if(counter = 15) then
                    done <= '1';
                    EN <= '1';
                    counter <= 0;
                    stop <= '1';
                end if;            
            end if;    
            
            if read = '0' then
                stop <= '0';
                done <= '0';
            end if;        
        end if;
    end process;
end Behavioral;
