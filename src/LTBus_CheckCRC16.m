function is_valid = LTBus_CheckCRC16(buffer, size)
%#codegen

arguments (Input)
    buffer(1, :) uint8
    size (1, 1) uint16
end

arguments (Output)
    is_valid (1, 1) logical
end

computed_crc16 = LTBus_Compute_CRC16(buffer(1:size - 3), size - 3);
packet_crc16 = typecast([buffer(size - 2), buffer(size - 1)], "uint16");
is_valid = isequal(computed_crc16, packet_crc16);
end
