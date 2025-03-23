library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity packet_forwarder is
    port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        dst_mac      : in  std_logic_vector(47 downto 0); -- Destination MAC
        src_mac      : in  std_logic_vector(47 downto 0); -- Source MAC
        ether_type   : in  std_logic_vector(15 downto 0); -- EtherType
        payload      : in  std_logic_vector(7 downto 0);  -- Payload byte
        payload_valid: in  std_logic;                     -- Valid signal for payload
        forward_packet: out std_logic                     -- Forward packet signal
    );
end entity;

architecture Behavioral of packet_forwarder is
    type forwarding_table_t is array (0 to 7) of std_logic_vector(47 downto 0);
    constant forwarding_table : forwarding_table_t := (
        x"DEADBEEF1234", -- Example MAC 1
        x"123456789ABC", -- Example MAC 2
        others => (others => '0')
    );
begin
    process(clk, reset)
    begin
        if reset = '1' then
            forward_packet <= '0';
        elsif rising_edge(clk) then
            if payload_valid = '1' then
                -- Check if destination MAC is in forwarding table
                forward_packet <= '0';
                for i in 0 to 7 loop
                    if dst_mac = forwarding_table(i) then
                        forward_packet <= '1';
                        exit;
                    end if;
                end loop;
            else
                forward_packet <= '0';
            end if;
        end if;
    end process;
end architecture;
