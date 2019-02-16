----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.10.2018 19:33:38
-- Design Name: 
-- Module Name: receiver_datapath - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity receiver_datapath is
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
end receiver_datapath;

architecture Behavioral of receiver_datapath is
   component hex_to_bcd 
     Port ( hex_byte : in STD_LOGIC_vector(7 downto 0);
         bcd_byte: out std_logic_vector(7 downto 0)
     );
  end component;

    component manchester_hamming_decoder 
    Port (EN: in std_logic;
        encode_in: in std_logic_vector(15 downto 0);
        decode_out: out std_logic_vector(3 downto 0);
        errors: out std_logic_vector(1 downto 0)
    );
    end component;
    
    signal EN: std_logic; -- enable, if not enabled decode_out reamains 0
    signal encode_in: std_logic_vector(63 downto 0);
    signal counter: integer range 0 to 63 := 0;    
    signal error1, error2, error3, error4: std_logic_vector(1 downto 0);
    signal error_count: std_logic_vector(7 downto 0);
    signal rx_count, incs_buff: std_logic_vector(7 downto 0);
    signal stop: std_logic := '0';
    signal counter2: integer range 0 to 127 := 0;
    
begin
    C1: manchester_hamming_decoder port map(EN, encode_in(15 downto 0), 
            decode_out(7 downto 4), error1);
    C2: manchester_hamming_decoder port map(EN, encode_in(31 downto 16), 
            decode_out(3 downto 0), error2);
    C3: hex_to_bcd port map(rx_count, bcd_count);
    C4: manchester_hamming_decoder port map(EN, encode_in(47 downto 32), 
            incs_buff(7 downto 4), error3);
    C5: manchester_hamming_decoder port map(EN, encode_in(63 downto 48), 
            incs_buff(3 downto 0), error4); 
    C6: hex_to_bcd port map(error_count, bcd_errors); 
    
    incs_test <= incs_buff;
    EN <= '1';
    
    process(clk, rst)
    variable packet_size: integer range 0 to 63;  
    variable once: std_logic;
    begin
    if(network = '1') then
        packet_size := 63;
    else
        packet_size := 31;
    end if;
     
    if rst = '1' then
        done <= '0';  
        r_flag <= '0';      
        retransmit <= (others => '0');
        encode_in <= (others => '0');
        error_count <= x"00";
        rx_count <= x"00";
        counter <= 0;
    elsif rising_edge(clk) then
        if read = '1' and stop <= '0' then
            --EN <= '0';
            encode_in(packet_size - counter) <= rx_in;
            counter <= counter + 1;
            if(counter = packet_size) then
                done <= '1';                
                counter <= 0;
                stop <= '1';                
                rx_count <= std_logic_vector(unsigned(rx_count) + 1 );                
            end if;            
        end if; 
        
        if(r_flag = '1') then
            counter2 <= counter2 + 1;
            if(counter2 = 100) then
            r_flag <= '0';
            counter2 <= 0;
            end if;
        end if;       
        
        --for one clock cycle
        if(stop = '1' and once = '0') then 
            error_count <= std_logic_vector(unsigned(error_count) + unsigned(error1) + unsigned(error2));
            if(incs_buff /= incs and network = '1') then
                retransmit(15 downto 8) <= incs_buff;
                retransmit(7 downto 0) <= decode_out;            
                encode_in <= (others => '0'); 
                           
                if(ring = '1') then
                    r_flag <= '1';
                end if;
                
            once := '1'; 
            end if;
        end if;
        
        if read = '0' then
            stop <= '0'; 
            done <= '0';
            once := '0';
        end if;        
    end if;
end process;
end Behavioral;
