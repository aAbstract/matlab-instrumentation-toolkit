function request_packet = LTBus_Write_I16_Request(address, value)
%#codegen

arguments (Input)
    address (1, 1) uint16
    value (1, 1) int16
end

arguments (Output)
    request_packet (1, 12) uint8
end

request_packet = zeros(1, 12, "uint8");

% LTBus Packet Start
request_packet(1) = 0x7B;
request_packet(2) = 0x01; % LTBUS_SLAVE_ID
request_packet(3) = 0xEA; % LTBUS_WRITE_FC

% LTBus WR Body
data_size = uint16(2);
request_packet(4:5) = typecast(address, "uint8");
request_packet(6:7) = typecast(data_size, "uint8");
request_packet(8:9) = typecast(value, "uint8");

% LTBus Packet End
crc16 = LTBus_Compute_CRC16(request_packet(1:9), 9);
request_packet(10:11) = typecast(crc16, "uint8");
request_packet(12) = 0x7D;

end
