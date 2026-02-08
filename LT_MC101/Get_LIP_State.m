function [M1_POS_FB, M1_SPD_FB, MAG_ENC1_ABS, MAG_ENC1_VEL] = Get_LIP_State()

arguments (Output)
    M1_POS_FB (1, 1) int32
    M1_SPD_FB (1, 1) int32
    MAG_ENC1_ABS (1, 1) uint16
    MAG_ENC1_VEL (1, 1) single
end

coder.extrinsic("read", "write");

M1_POS_FB = int32(0);
M1_SPD_FB = int32(0);
MAG_ENC1_ABS = uint16(0);
MAG_ENC1_VEL = single(0);

conf = Get_Conf();
packet_size = conf.LTBus_packet_size;

ltbus_device = ML_Get_Device_Port();
persistent LIP_init
if isempty(LIP_init)
    write(ltbus_device, [0x7B 0x01 0xEA 0x7E 0xD0 0x02 0x00 0x01 0x50 0x2B 0xCD 0x7D], "uint8");
    LIP_init = true;
end

read_request = LTBus_Read_Request(0xD000, packet_size - 10);

while true
    write(ltbus_device, read_request, "uint8");
    bytes_available = double(0); %#ok
    bytes_available = get(ltbus_device, "BytesAvailable");
    if bytes_available > 0
        break;
    end
end

response_packet = uint8(read(ltbus_device, bytes_available, "uint8"));
response_packet = response_packet(end-packet_size+1:end);
flush(ltbus_device);
if response_packet(1) ~= 123 || response_packet(end) ~= 125
    return
end

M1_POS_FB_offset = (0x014 + 8);
M1_SPD_FB_offset = (0x01C + 8);
MAG_ENC1_ABS_offset = (0x034 + 8);
MAG_ENC1_VEL_offset = (0x03C + 8);

M1_POS_FB_bytes = response_packet(M1_POS_FB_offset:M1_POS_FB_offset + 3);
M1_SPD_FB_bytes = response_packet(M1_SPD_FB_offset:M1_SPD_FB_offset + 3);
MAG_ENC1_ABS_bytes = response_packet(MAG_ENC1_ABS_offset:MAG_ENC1_ABS_offset + 1);
MAG_ENC1_VEL_bytes = response_packet(MAG_ENC1_VEL_offset:MAG_ENC1_VEL_offset + 3);

M1_POS_FB = typecast(M1_POS_FB_bytes, "int32");
M1_SPD_FB = typecast(M1_SPD_FB_bytes, "int32");
MAG_ENC1_ABS = typecast(MAG_ENC1_ABS_bytes, "uint16");
MAG_ENC1_VEL = typecast(MAG_ENC1_VEL_bytes, "single");

end
