library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mac_security_filter is
    generic (
        MAC_LIST_SIZE : integer := 4
    );
    port (
        src_mac      : in  std_logic_vector(47 downto 0);
        dst_mac      : in  std_logic_vector(47 downto 0);
        mode         : in  std_logic; -- 0 = whitelist, 1 = blacklist
        mac_list     : in  std_logic_vector(47 downto 0 * MAC_LIST_SIZE);
        allow_packet : out std_logic
    );
end entity;

architecture Behavioral of mac_security_filter is
    signal src_match, dst_match : std_logic := '0';
begin
    -- Check if src_mac or dst_mac matches any address in the list
    process(src_mac, dst_mac, mac_list)
    begin
        src_match <= '0';
        dst_match <= '0';
        for i in 0 to MAC_LIST_SIZE-1 loop
            if src_mac = mac_list(47+48*i downto 48*i) then
                src_match <= '1';
            end if;
            if dst_mac = mac_list(47+48*i downto 48*i) then
                dst_match <= '1';
            end if;
        end loop;
    end process;

    -- Determine if packet is allowed based on mode
    allow_packet <= (src_match or dst_match) when mode = '0' else
                    not (src_match or dst_match);
end architecture;
