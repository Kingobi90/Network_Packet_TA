library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity packet_filter is
    port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        ether_type   : in  std_logic_vector(15 downto 0); -- EtherType
        filter_allow : out std_logic                      -- Allow packet signal
    );
end entity;

architecture Behavioral of packet_filter is
    constant ALLOWED_ETHER_TYPES : std_logic_vector(15 downto 0) := x"0800"; -- Example: IPv4
begin
    process(clk, reset)
    begin
        if reset = '1' then
            filter_allow <= '0';
        elsif rising_edge(clk) then
            if ether_type = ALLOWED_ETHER_TYPES then
                filter_allow <= '1';
            else
                filter_allow <= '0';
            end if;
        end if;
    end process;
end architecture;
