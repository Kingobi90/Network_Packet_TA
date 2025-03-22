# Ethernet Packet Processor

This project implements a basic Ethernet packet processor in VHDL. It includes modules for parsing, filtering, forwarding, and CRC checking of Ethernet packets.

## Modules
- **Packet Parser**: Extracts Ethernet frame fields.
- **Packet Filter**: Filters packets based on MAC addresses or EtherType.
- **Packet Forwarder**: Forwards packets based on a simple forwarding table.
- **CRC Checker**: Verifies the integrity of incoming packets.

## Testbench
A testbench is provided to simulate the system with sample Ethernet packets.

## Usage
1. Compile the VHDL files using your preferred VHDL simulator.
2. Run the testbench to verify the functionality.
