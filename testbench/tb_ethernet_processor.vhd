library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ethernet_processor is
end entity;

architecture Behavioral of tb_ethernet_processor is
    -- Testbench signals
    signal clk, reset : std_logic := '0';
    signal packet_in : std_logic_vector(7 downto 0);
    signal packet_valid : std_logic;
    signal forward_packet, suspicious_packet, crc_valid : std_logic;

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;
begin
    -- Instantiate the Ethernet Processor
    uut: entity work.ethernet_processor
        port map (
            clk              => clk,
            reset            => reset,
            packet_in        => packet_in,
            packet_valid     => packet_valid,
            forward_packet   => forward_packet,
            suspicious_packet=> suspicious_packet,
            crc_valid        => crc_valid
        );

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Test process
    test_process: process
    begin
        -- Initialize
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';

        -- Test 1: Valid packet (whitelist MAC, correct CRC)
        packet_in <= x"DE"; -- Example packet byte
        packet_valid <= '1';
        wait for CLK_PERIOD;
        assert forward_packet = '1' report "Test 1: Valid packet failed" severity error;

        -- Test 2: Suspicious packet (length > 1000)
        packet_in <= x"FF"; -- Example packet byte
        packet_valid <= '1';
        wait for CLK_PERIOD;
        assert suspicious_packet = '1' report "Test 2: Suspicious packet failed" severity error;

        -- Test 3: Invalid CRC
        packet_in <= x"00"; -- Example packet byte
        packet_valid <= '1';
        wait for CLK_PERIOD;
        assert crc_valid = '0' report "Test 3: Invalid CRC failed" severity error;

        -- End of tests
        wait;
    end process;
end architecture;
