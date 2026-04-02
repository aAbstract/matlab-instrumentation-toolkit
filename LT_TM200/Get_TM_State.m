function [LOAD, GAUGE] = Get_TM_State()

arguments (Output)
    LOAD (1, 1) single
    GAUGE (1, 1) int16
end

coder.extrinsic("read", "write", "flush");

LOAD = int16(0);
GAUGE = single(0);

conf = Get_Conf();
packet_size = conf.LTBus_packet_size;

ltbus_device = ML_Get_Device_Port();
persistent TM_init
persistent last_LOAD
persistent last_GAUGE
if isempty(TM_init)
    write(ltbus_device, [0x7B 0x01 0xEA 0x0E 0xD0 0x02 0x00 0x03 0x00 0x1F 0x69 0x7D], "uint8");

    last_LOAD = LOAD;
    last_GAUGE = GAUGE;

    TM_init = true;
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
    LOAD = last_LOAD;
    GAUGE = last_GAUGE;
    return;
end

LOAD_offset = (0x000 + 8);
GAUGE_offset = (0x004 + 8);

LOAD_bytes = response_packet(LOAD_offset:LOAD_offset + 3);
GAUGE_bytes = response_packet(GAUGE_offset:GAUGE_offset + 3);

LOAD = typecast(LOAD_bytes, "single");
GAUGE = typecast(GAUGE_bytes, "single");

last_LOAD = LOAD;
last_GAUGE = GAUGE;

end
