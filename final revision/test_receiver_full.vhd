----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.10.2018 20:20:20
-- Design Name: 
-- Module Name: test_receiver_full - Behavioral
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

entity test_receiver_full is
--  Port ( );
end test_receiver_full;

architecture Behavioral of test_receiver_full is

    component receiver_general 
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
    end component;
    
    signal rx_in, clk, rst, read_sig, done_sig: std_logic := '0';
    signal decode_out: std_logic_vector(7 downto 0);
    signal bcd_errors, incs_test: std_logic_vector(7 downto 0);
    signal bcd_count, incs: std_logic_vector(7 downto 0);
    signal retransmit: std_logic_vector(15 downto 0);
    signal r_flag, network, ring: std_logic;

begin
    uut: receiver_general port map(rx_in, clk, rst, decode_out, bcd_errors, network,
            ring, read_sig, done_sig, incs, retransmit, r_flag, bcd_count, incs_test);

    clk <= not clk after 5ns;
    
    process
    variable input1: std_logic_vector(71 downto 0) := x"166a559a655555a696";
    variable input2: std_logic_vector(71 downto 0) := x"166a559a66695669a6";
    
    begin
    rst <= '1';
    wait for 10ns;
    rst <= '0';
    network <= '1';
    ring <= '1';
    
    incs <= x"75";
    
    for I in 0 to 70 loop
        rx_in <= input1(70 - I);
        wait for 10ns;
    end loop;
    
    incs <= x"85";
    
    for I in 0 to 70 loop
        rx_in <= input1(70 - I);
        wait for 10ns;
    end loop;
    
    incs <= x"75";
    wait for 20ns;
    
    for I in 0 to 70 loop
        rx_in <= input2(70 - I);
        wait for 10ns;
    end loop;
    
    incs <= x"85";
    for I in 0 to 70 loop
        rx_in <= input2(70 - I);
        wait for 10ns;
    end loop;     
    
    wait for 200ns;    
    end process;

end Behavioral;
