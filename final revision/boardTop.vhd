----------------------------------------------------------------------------------
-- Company: University of Queensland
-- Engineer: MDS
-- 
-- Create Date:    25/07/2014 
-- Design Name: 
-- Module Name:    boardTop - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity boardTop is
    Port ( ssegAnode : out  STD_LOGIC_VECTOR (7 downto 0);
           ssegCathode : out  STD_LOGIC_VECTOR (7 downto 0);
           slideSwitches : in  STD_LOGIC_VECTOR (15 downto 0);
           pushButtons : in  STD_LOGIC_VECTOR (4 downto 0);
           LEDs : out  STD_LOGIC_VECTOR (15 downto 0);
           columns: out std_logic_vector(3 downto 0);
           rows: in std_logic_vector(3 downto 0);
           tx: out std_logic;
           rx, ext_clk, ext_clk2: in std_logic;
			  clk100mhz : in STD_LOGIC;
			  logic_analyzer : out STD_LOGIC_VECTOR (7 downto 0));
end boardTop;

architecture Behavioral of boardTop is

component module1
Port (slideSwitches: in std_logic_vector(15 downto 0);
    rst, clk: in std_logic;
    data_in: in std_logic_vector(31 downto 0);
    BTNL: in std_logic;
    BTNR: in std_logic;
    connect, ring: out std_logic;
    ssegAnode: out std_logic_vector(7 downto 0);
    ssegCathode: out std_logic_vector(7 downto 0)
    );
end component;

component keypad
    Port (clk : in  STD_LOGIC;
        flag: out std_logic;
        Row : in  STD_LOGIC_VECTOR (3 downto 0);
        Col : out  STD_LOGIC_VECTOR (3 downto 0);
        DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0)       
        );
end component;

component transmitter_general 
    Port (raw: in std_logic_vector (3 downto 0);
    flag, clk, rst, ss2, network: in std_logic; --ss2 = slide switch 2
    hamming_errors: in std_logic_vector(7 downto 0);
    sig_out: out std_logic;
    incs: out std_logic_vector(7 downto 0);
    byte: out std_logic_vector(7 downto 0);
    retransmit: in std_logic_vector(15 downto 0);
    r_flag: in std_logic; -- from receiver 
    bcd_count: out std_logic_vector(7 downto 0)     
    );
end component;

component receiver_general 
    Port (rx_in: in std_logic;
        clk, rst: in std_logic;
        decode_out: inout std_logic_vector(7 downto 0);
        bcd_errors: out std_logic_vector(7 downto 0);
        network, ring: in std_logic;
        incs: in std_logic_vector(7 downto 0);
        retransmit: out std_logic_vector(15 downto 0);
        r_flag: inout std_logic; --flag to retransmit
        bcd_count: out std_logic_vector(7 downto 0)
    );
end component;

component bus_interface
Port (flag: in std_logic; --used for rx    
    rst, clk: in std_logic;
    read_req_test, dataRdy_test: out std_logic; 
    ack1_test: out std_logic;
    ack2_test: out std_logic;      
    addr: in std_logic_vector(17 downto 0); -- 6 times 3 - 1
    modData: in std_logic_vector(191 downto 0); --6 times 32 - 1
    modDataO: out std_logic_vector(191 downto 0) --6 times 32 - 1
);
end component;

component samp_clk 
Port (clkin, clk: in std_logic;
    clkout: out std_logic
);
end component;

component ram 
Port (address: in std_logic_vector(4 downto 0); --32 times 1-byte
    tx_addr: in std_logic_vector(4 downto 0);
    d_in: in std_logic_vector(7 downto 0);
    we, re: in std_logic;
    clk, rst: in std_logic;
    d_out: out std_logic_vector(15 downto 0)
    );
end component;

--flag refers to decoder
--r_flag refers to retransmit
signal r_flag, flag, ss0, ss1, ss2, connected, ring: std_logic;
signal buff_addr: std_logic_vector(4 downto 0);
signal master_reset, sig_out: std_logic;
signal raw: std_logic_vector(3 downto 0);
signal clk, carrier: std_logic;
signal decode, hamming_errors, incs: std_logic_vector(7 downto 0);
signal byte, bcd_count, bcd_errors, rx_bcd: std_logic_vector(7 downto 0);
signal spare, retransmit, d_out: std_logic_vector(15 downto 0);
signal modIn, modOut: std_logic_vector(191 downto 0) := (others => '0');
signal addr: std_logic_vector(17 downto 0);
signal acko, acki, read_req, dataRdy: std_logic; 
signal ssegDig: std_logic_vector(31 downto 0);
signal topology: std_logic;
signal sig_in: std_logic;

begin
    C1: module1 port map(slideSwitches => slideSwitches, rst => master_reset, 
            data_in => ssegDig, clk => clk, BTNL => pushButtons(3), 
            BTNR => pushButtons(0), connect => connected, ring => topology,
            ssegAnode => ssegAnode, ssegCathode => ssegCathode);
    
    C2: keypad port map(clk100mhz, flag, rows, columns, raw);
    
    C3: bus_interface port map('1', master_reset, clk, read_req, dataRdy, acki, 
            acko, addr, modIn, modOut);
    
    C4: transmitter_general port map(raw => modOut(100 downto 97), flag => modOut(96), clk => clk, 
            rst => master_reset, ss2 => ss2, network => connected, hamming_errors => hamming_errors, 
            sig_out => sig_out, incs => incs, byte => byte, retransmit => modOut(111 downto 96), r_flag => r_flag, 
            bcd_count => bcd_count);
            
    C5: samp_clk port map(ext_clk, clk100mhz, clk);
    C8: samp_clk port map(ext_clk2, clk100mhz, carrier);
    --retransmit transferred using bus instead
    C6: receiver_general port map(sig_in, clk, master_reset, decode, bcd_errors, 
            connected, ring, x"75", retransmit, r_flag, rx_bcd);
    --for receiving use rx_count else use switches(        
    C7: ram port map(modOut(60 downto 56), --rx_bcd
            buff_addr, decode, '1', '1', clk, master_reset, d_out);            

ssegDig(31 downto 24) <= modOut(191 downto 184) when ss1 = '0' else
    modOut(63 downto 56); --rx_bcd
ssegDig(23 downto 16) <= modOut(55 downto 48); --bcd-errors 
ssegDig(15 downto 0) <= retransmit when slideSwitches(15) = '1' else
    modOut(175 downto 160) when ss0 = '0' else
    modOut(95 downto 80); -- d_out    

sig_in <= not rx;
ring <= topology and connected;
tx <= sig_out and carrier;
LEDs(0) <= not connected;
LEDs(1) <= connected;
LEDs(2) <= ring;

--Bus interface addresses
addr(17 downto 15) <= "010"; --module 3 (191 to 160)
addr(14 downto 12) <= "111"; --none (159 to 128)
addr(11 downto 9) <= "001" when r_flag = '0' else
        "000"; --module 2 if not r_flag else module 1 for retransmit info (127 to 96)
addr(8 downto 6) <= "100"; -- module6 (95 to 64)
addr(5 downto 3) <= "011"; --module 4
addr(2 downto 0) <= "111"; --no module connected here
--Bus interface inputs

--decoder
modIn(132 downto 129) <= raw;
modIn(128) <= flag;
--tx
modIn(127 downto 120) <= bcd_count;
modIn(119 downto 112) <= (others => '0');
modIn(111 downto 104) <= incs;
modIn(103 downto 96) <= byte;
--rx
modIn(95 downto 88) <= rx_bcd;
modIn(87 downto 80) <= bcd_errors;
modIn(79 downto 72) <= decode; --temporarily display outputs
--recv buffer
modIn(63 downto 48) <= d_out;
--extra
modIn(176 downto 161) <= retransmit;

hamming_errors <= slideSwitches(14 downto 7);
ss2 <= slideSwitches(2);
ss1 <= slideSwitches(1);
ss0 <= slideSwitches(0);
buff_addr <= slideSwitches(6 downto 2);    

logic_analyzer(3) <= acki;
logic_analyzer(2) <= acko;
logic_analyzer(1) <= dataRdy;
logic_analyzer(0) <= read_req;
    
master_reset <= pushButtons(4);
end Behavioral;

