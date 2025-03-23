library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ethernet_processor is
    port (
        clk              : in  std_logic;
        reset            : in  std_logic;
        packet_in        : in  std_logic_vector(7 downto 0); -- Input packet byte
        packet_valid     : in  std_logic;                    -- Valid signal for input byte
        forward_packet   : out std_logic;                    -- Forward packet signal
        suspicious_packet: out std_logic;                    -- Suspicious packet signal
        crc_valid        : out std_logic                     -- CRC validation result
    );
end entity;

architecture Behavioral of ethernet_processor is
    -- Signals for inter-module communication
    signal dst_mac, src_mac : std_logic_vector(47 downto 0);
    signal ether_type       : std_logic_vector(15 downto 0);
    signal payload          : std_logic_vector(7 downto 0);
    signal payload_valid    : std_logic;
    signal filter_allow     : std_logic;
    signal allow_packet     : std_logic;
begin
    -- Instantiate Packet Parser
    packet_parser_inst: entity work.packet_parser
        port map (
            clk          => clk,
            reset        => reset,
            packet_in    => packet_in,
            packet_valid => packet_valid,
            dst_mac      => dst_mac,
            src_mac      => src_mac,
            ether_type   => ether_type,
            payload      => payload,
            payload_valid=> payload_valid
        );

    -- Instantiate Packet Filter
    packet_filter_inst: entity work.packet_filter
        port map (
            clk          => clk,
            reset        => reset,
            ether_type   => ether_type,
            filter_allow => filter_allow
        );

    -- Instantiate Packet Forwarder
    packet_forwarder_inst: entity work.packet_forwarder
        port map (
            clk          => clk,
            reset        => reset,
            dst_mac      => dst_mac,
            src_mac      => src_mac,
            ether_type   => ether_type,
            payload      => payload,
            payload_valid=> payload_valid,
            forward_packet=> forward_packet
        );

    -- Instantiate CRC Checker
    crc_checker_inst: entity work.crc_checker
        port map (
            clk          => clk,
            reset        => reset,
            packet_in    => packet_in,
            packet_valid => packet_valid,
            crc_valid    => crc_valid
        );

    -- Instantiate MAC Security Filter
    mac_security_filter_inst: entity work.mac_security_filter
        port map (
            src_mac      => src_mac,
            dst_mac      => dst_mac,
            mode         => '0', -- 0 = whitelist, 1 = blacklist
            mac_list     => (others => '0'), -- Example MAC list
            allow_packet => allow_packet
        );

    -- Instantiate Anomaly Detector
    anomaly_detector_inst: entity work.anomaly_detector
        port map (
            clk              => clk,
            reset            => reset,
            src_mac          => src_mac,
            packet_length    => to_integer(unsigned(payload)),
            packet_valid     => payload_valid,
            suspicious_packet=> suspicious_packet
        );
end architecture;