-- Instantiate MAC security filter
mac_filter: entity work.mac_security_filter
    generic map (
        MAC_LIST_SIZE => 4
    )
    port map (
        src_mac      => src_mac,
        dst_mac      => dst_mac,
        mode         => filter_mode,
        mac_list     => mac_list,
        allow_packet => allow_packet
    );
