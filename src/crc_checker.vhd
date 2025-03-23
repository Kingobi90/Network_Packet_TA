library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity crc_checker is
    port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        packet_in    : in  std_logic_vector(7 downto 0); -- Input packet byte
        packet_valid : in  std_logic;                    -- Valid signal for input byte
        crc_valid    : out std_logic                     -- CRC validation result
    );
end entity;

architecture Behavioral of crc_checker is
    signal crc_reg : std_logic_vector(31 downto 0) := (others => '1');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            crc_reg <= (others => '1');
            crc_valid <= '0';
        elsif rising_edge(clk) then
            if packet_valid = '1' then
                -- Update CRC register
                crc_reg(0)  <= packet_in(7) xor crc_reg(24);
                crc_reg(1)  <= packet_in(6) xor crc_reg(25);
                crc_reg(2)  <= packet_in(5) xor crc_reg(26);
                crc_reg(3)  <= packet_in(4) xor crc_reg(27);
                crc_reg(4)  <= packet_in(3) xor crc_reg(28);
                crc_reg(5)  <= packet_in(2) xor crc_reg(29);
                crc_reg(6)  <= packet_in(1) xor crc_reg(30);
                crc_reg(7)  <= packet_in(0) xor crc_reg(31);
                crc_reg(8)  <= crc_reg(0);
                crc_reg(9)  <= crc_reg(1);
                crc_reg(10) <= crc_reg(2);
                crc_reg(11) <= crc_reg(3);
                crc_reg(12) <= crc_reg(4);
                crc_reg(13) <= crc_reg(5);
                crc_reg(14) <= crc_reg(6);
                crc_reg(15) <= crc_reg(7);
                crc_reg(16) <= crc_reg(8);
                crc_reg(17) <= crc_reg(9);
                crc_reg(18) <= crc_reg(10);
                crc_reg(19) <= crc_reg(11);
                crc_reg(20) <= crc_reg(12);
                crc_reg(21) <= crc_reg(13);
                crc_reg(22) <= crc_reg(14);
                crc_reg(23) <= crc_reg(15);
                crc_reg(24) <= crc_reg(16);
                crc_reg(25) <= crc_reg(17);
                crc_reg(26) <= crc_reg(18);
                crc_reg(27) <= crc_reg(19);
                crc_reg(28) <= crc_reg(20);
                crc_reg(29) <= crc_reg(21);
                crc_reg(30) <= crc_reg(22);
                crc_reg(31) <= crc_reg(23);
            end if;

            -- Check CRC at the end of the packet
            if packet_valid = '0' and crc_reg /= x"FFFFFFFF" then
                crc_valid <= '1'; -- CRC is valid
            else
                crc_valid <= '0'; -- CRC is invalid
            end if;
        end if;
    end process;
end architecture;