function request_packet = LTBus_Read_Request(address, data_size)
%#codegen

arguments (Input)
    address (1, 1) uint16
    data_size (1, 1) uint16
end

arguments (Output)
    request_packet (1, 10) uint8
end

request_packet = zeros(1, 10, "uint8");

% LTBus Packet Start
request_packet(1) = 0x7B;
request_packet(2) = 0x01; % LTBUS_SLAVE_ID
request_packet(3) = 0xAA; % LTBUS_READ_FC

% LTBus RR Body
request_packet(4:5) = typecast(address, "uint8");
request_packet(6:7) = typecast(data_size, "uint8");

% LTBus Packet End
crc16 = LTBus_Compute_CRC16(request_packet(1:7), 7);
request_packet(8:9) = typecast(crc16, "uint8");
request_packet(10) = 0x7D;
end
