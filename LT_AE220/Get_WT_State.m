function [DIFF_PRES] = Get_WT_State()

arguments (Output)
    DIFF_PRES (1, 1) single
end

coder.extrinsic("read", "write", "flush");

DIFF_PRES = single(0);

conf = Get_Conf();
packet_size = conf.LTBus_packet_size;

ltbus_device = ML_Get_Device_Port();
persistent WT_init
persistent last_DIFF_PRES
if isempty(WT_init)
    % write(ltbus_device, [0x7B 0x01 0xEA 0x0E 0xD0 0x02 0x00 0x1B 0x00 0x4E 0x32 0x7D], "uint8");

    last_DIFF_PRES = DIFF_PRES;

    WT_init = true;
end

read_request = LTBus_Read_Request(0xD000, packet_size - 10);
write(ltbus_device, read_request, "uint8");

c = 0;
while true
    if c >= 1E3
        write(ltbus_device, read_request, "uint8");
        c = 0;
        continue;
    end

    bytes_available = double(0); %#ok
    bytes_available = get(ltbus_device, "BytesAvailable");
    if bytes_available > 0
        break;
    end
    pause(1E-6);
    c = c + 1;
end

response_packet = zeros(1, bytes_available, "uint8"); %#ok
response_packet = uint8(read(ltbus_device, bytes_available, "uint8"));
response_packet = response_packet(bytes_available-packet_size+1:bytes_available);
flush(ltbus_device);
if response_packet(1) ~= 0x7B || response_packet(packet_size) ~= 0x7D || ~LTBus_CheckCRC16(response_packet, uint16(packet_size))
    DIFF_PRES = last_DIFF_PRES;
    return;
end

DIFF_PRES_offset = (0x024 + 8);

DIFF_PRES_bytes = response_packet(DIFF_PRES_offset:DIFF_PRES_offset + 3);

DIFF_PRES = typecast(DIFF_PRES_bytes, "single");

last_DIFF_PRES = DIFF_PRES;

end
