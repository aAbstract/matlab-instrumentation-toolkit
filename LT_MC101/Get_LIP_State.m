function [M1_POS_FB, M1_SPD_FB, MAG_ENC1_ABS, MAG_ENC1_VEL] = Get_LIP_State()

arguments (Output)
    M1_POS_FB (1, 1) int32
    M1_SPD_FB (1, 1) int32
    MAG_ENC1_ABS (1, 1) uint16
    MAG_ENC1_VEL (1, 1) single
end

coder.extrinsic("read", "write");

M1_POS_FB = int32(0); %#ok
M1_SPD_FB = int32(0); %#ok
MAG_ENC1_ABS = uint16(0); %#ok
MAG_ENC1_VEL = single(0); %#ok

conf = Get_Conf();
packet_size = conf.LTBus_packet_size;

ltbus_device = ML_Get_Device_Port();
read_request = LTBus_Read_Request(0xD000, packet_size - 10);
write(ltbus_device, read_request, "uint8");
response_packet = uint8(read(ltbus_device, packet_size, "uint8"));

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
