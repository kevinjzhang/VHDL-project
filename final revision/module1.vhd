----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2018 10:19:05
-- Design Name: 
-- Module Name: module1 - Behavioral
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

entity module1 is
Port (slideSwitches: in std_logic_vector(15 downto 0);
    rst, clk: in std_logic;
    data_in: in std_logic_vector(31 downto 0);
    BTNL: in std_logic;
    BTNR: in std_logic;
    connect, ring: out std_logic;
    ssegAnode: out std_logic_vector(7 downto 0);
    ssegCathode: out std_logic_vector(7 downto 0)
    );
end module1;

architecture Behavioral of module1 is
    component ssegDriver port (
        clk : in std_logic;
        rst : in std_logic;
        cathode_p : out std_logic_vector(7 downto 0);
        digit1_p : in std_logic_vector(3 downto 0);
        anode_p : out std_logic_vector(7 downto 0);
        digit2_p : in std_logic_vector(3 downto 0);
        digit3_p : in std_logic_vector(3 downto 0);
        digit4_p : in std_logic_vector(3 downto 0);
        digit5_p : in std_logic_vector(3 downto 0);
        digit6_p : in std_logic_vector(3 downto 0);
        digit7_p : in std_logic_vector(3 downto 0);
        digit8_p : in std_logic_vector(3 downto 0)
    ); 
    end component;
    
    type state_type is (s1, s2, s3);
    signal state1, state2: state_type;
    
    signal digit1_p, digit2_p, digit3_p, digit4_p, digit5_p, digit6_p, digit7_p, digit8_p : std_logic_vector(3 downto 0);
    signal connected: std_logic := '0'; 
    signal topology: std_logic := '0'; -- 0 for point to point, 1 for ring
begin
    --data-in 
    C1: ssegDriver port map(clk, rst, ssegCathode, digit1_p, ssegAnode, digit2_p, 
    digit3_p, digit4_p, digit5_p, digit6_p, digit7_p, digit8_p);
    
    connect <= connected;
    ring <= topology;
    
    digit1_p <= data_in(3 downto 0);
    digit2_p <= data_in(7 downto 4);
    digit3_p <= data_in(11 downto 8);
    digit4_p <= data_in(15 downto 12);
    digit5_p <= data_in(19 downto 16);
    digit6_p <= data_in(23 downto 20);
    digit7_p <= data_in(27 downto 24);
    digit8_p <= data_in(31 downto 28);    

    process(clk, rst)
    begin
        if(rst = '1') then
            state1 <= s1;
            state2 <= s1;
            topology <= '0';
            connected <= '0';
        elsif rising_edge(clk) then
            case state1 is
                when s1 =>
                    if(BTNL = '1') then
                        state1 <= s2;
                    else
                        state1 <= s1;
                    end if;
                when s2 =>
                    if(BTNL = '1') then
                        state1 <= s2;
                    else
                        state1 <= s3;
                    end if;                    
                when s3 =>
                    state1 <= s1;
                    connected <= not connected;
            end case;
            
            case state2 is
                when s1 =>
                    if(BTNR = '1') then
                        state2 <= s2;
                    else
                        state2 <= s1;
                    end if;                
                when s2 =>
                    if(BTNR = '1') then
                        state2 <= s2;
                    else
                        state2 <= s3;
                    end if;                
                when s3 =>
                    state2 <= s1;
                    topology <= not topology;
            end case;                         
        end if;
    end process;
end Behavioral;
