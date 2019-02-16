----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2018 13:06:56
-- Design Name: 
-- Module Name: transmit_datapath - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transmit_datapath is
Port (raw: in std_logic_vector (3 downto 0);
    clk, rst: in std_logic;
    ss2: in std_logic; -- to toggle for hex character sending
    flag: in std_logic; -- from decoder
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
end transmit_datapath;

architecture Behavioral of transmit_datapath is
   component hex_to_bcd 
        Port ( hex_byte : in STD_LOGIC_vector(7 downto 0);
            bcd_byte: out std_logic_vector(7 downto 0)
        );
    end component;

    component hamming_manchester_encoder2 
    --note actual data out
    Port (raw: in std_logic_vector(3 downto 0);
        hamming_errors: in std_logic_vector(7 downto 0);
        encode_out: out std_logic_vector(15 downto 0)
        );
    end component;
    
    signal incs_packet: std_logic_vector(69 downto 0);
    signal typ_packet: std_logic_vector(37 downto 0);
    signal incs: std_logic_vector (7 downto 0);
    signal byte: std_logic_vector (7 downto 0);
    signal counter: integer range 0 to 127 := 0;
    signal tx_count: std_logic_vector(7 downto 0);
    signal stop: std_logic := '0';
begin
    incs_test <= incs;
    byte_test <= byte;
    test_sig <= incs_packet;
    
    typ_packet(37 downto 34) <= "0101";
    typ_packet(1 downto 0) <= "10";
    

    C1: hamming_manchester_encoder2 port map(raw => byte(3 downto 0), hamming_errors => hamming_errors, 
            encode_out => typ_packet(33 downto 18));
    C2: hamming_manchester_encoder2 port map(raw => byte(7 downto 4), hamming_errors => hamming_errors, 
            encode_out => typ_packet(17 downto 2));
    C3: hamming_manchester_encoder2 port map(raw => incs(3 downto 0), hamming_errors => x"00", 
            encode_out => incs_packet(65 downto 50));
    C4: hamming_manchester_encoder2 port map(raw => incs(7 downto 4), hamming_errors => x"00", 
            encode_out => incs_packet(49 downto 34));
    C5: hex_to_bcd port map(tx_count, bcd_count);
            
    incs_packet(33 downto 0) <= typ_packet(33 downto 0); 
    incs_packet(69 downto 66) <= typ_packet(37 downto 34);  
    
    read_packet: process(clk, rst)
    begin
        if rst = '1' then
            incs <= x"75";
            byte <= x"00";
        elsif rising_edge(clk) then
            if(r_flag = '1') then
                incs <= retransmit(15 downto 8);
                byte <= retransmit(7 downto 0);
            elsif(ss2 = '0') then
                if (num1 = '1') then
                    byte(7 downto 4) <= raw; 
                end if;            
                if (num2 = '1') then
                    byte(3 downto 0) <= raw;
                end if;
            else 
                if (num1 = '1') then
                    incs(7 downto 4) <= raw;
                end if;            
                if (num2 = '1') then
                    incs(3 downto 0) <= raw;
                end if;            
            end if;                        
        end if;
    end process;          

    send_packet: process(clk, rst)
    variable packet_size: integer range 0 to 127;
    begin
        if network = '1' or r_flag = '1' then
            packet_size := 70;
        else
            packet_size := 38;
        end if;
    
        if rst = '1' then
            done <= '0';
            counter <= 0;
            tx_count <= x"00";
            sig_out <= '0';
        elsif rising_edge(clk) then
            --stores in the send buffer
            if(send = '1' and counter = 0) then
                counter <= counter + 1;        
            --the cycle after stored in the send buffer
            elsif(send = '1' and stop = '0' and counter /= 0) then
                done <= '0';               
                if network = '1' or r_flag = '1' then
                    sig_out <= incs_packet(packet_size - counter);
                else
                    sig_out <= typ_packet(packet_size - counter);
                end if;
                counter <= counter + 1;
                if(counter = packet_size) then
                    tx_count <= tx_count + 1;
                    done <= '1';
                    counter <= 0;
                    stop <= '1'; --forces a stop to sending before send is 0 again
                end if;
            end if;
            
            --the cycle after send is set to 0 force stop no longer
            --required
            if(send = '0') then
                stop <= '0';
                done <= '0';
            end if;
        end if;
    end process;
end Behavioral;
