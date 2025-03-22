library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity anomaly_detector is
    generic (
        SUSPICIOUS_MAC    : std_logic_vector(47 downto 0) := x"DEADBEEF1234"; -- Example MAC
        PACKET_LENGTH_THR : integer := 1000; -- Threshold for packet length
        PACKET_RATE_THR   : integer := 10;   -- Threshold for packet rate
        TIME_WINDOW       : integer := 1000  -- Time window in clock cycles
    );
    port (
        clk              : in  std_logic;
        reset            : in  std_logic;
        src_mac          : in  std_logic_vector(47 downto 0);
        packet_length    : in  integer;
        packet_valid     : in  std_logic;
        suspicious_packet: out std_logic
    );
end entity;

architecture Behavioral of anomaly_detector is
    signal packet_count : integer := 0;
    signal time_counter : integer := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            packet_count <= 0;
            time_counter <= 0;
            suspicious_packet <= '0';
        elsif rising_edge(clk) then
            -- Rule 1: Check if src_mac matches and packet length exceeds threshold
            if src_mac = SUSPICIOUS_MAC and packet_length > PACKET_LENGTH_THR then
                suspicious_packet <= '1';
            else
                suspicious_packet <= '0';
            end if;

            -- Rule 2: Check packet rate within time window
            if packet_valid = '1' then
                packet_count <= packet_count + 1;
            end if;

            if time_counter < TIME_WINDOW then
                time_counter <= time_counter + 1;
            else
                if packet_count > PACKET_RATE_THR then
                    suspicious_packet <= '1';
                end if;
                packet_count <= 0;
                time_counter <= 0;
            end if;
        end if;
    end process;
end architecture;
