function [MAG_ENC1_ABS, MAG_ENC1_VEL, MAG_ENC2_ABS, MAG_ENC2_VEL, TCH_GRID_X, TCH_GRID_Y, TCH_VEL_X, TCH_VEL_Y] = Get_PB_State()

arguments (Output)
    MAG_ENC1_ABS (1, 1) uint16
    MAG_ENC1_VEL (1, 1) single
    MAG_ENC2_ABS (1, 1) uint16
    MAG_ENC2_VEL (1, 1) single
    TCH_GRID_X (1, 1) single
    TCH_GRID_Y (1, 1) single
    TCH_VEL_X (1, 1) single
    TCH_VEL_Y (1, 1) single
end

coder.extrinsic("read", "write");

MAG_ENC1_ABS = uint16(0);
MAG_ENC1_VEL = single(0);
MAG_ENC2_ABS = uint16(0);
MAG_ENC2_VEL = single(0);
TCH_GRID_X = single(0);
TCH_GRID_Y = single(0);
TCH_VEL_X = single(0);
TCH_VEL_Y = single(0);

conf = Get_Conf();
packet_size = conf.LTBus_packet_size;

ltbus_device = ML_Get_Device_Port();
persistent PB_init
if isempty(PB_init)
    write(ltbus_device, [0x7B 0x01 0xEA 0x7E 0xD0 0x02 0x00 0x01 0x30 0x2D 0xAE 0x7D], "uint8");
    PB_init = true;
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

MAG_ENC1_ABS_offset = (0x034 + 8);
MAG_ENC1_VEL_offset = (0x03C + 8);
MAG_ENC2_ABS_offset = (0x036 + 8);
MAG_ENC2_VEL_offset = (0x040 + 8);
TCH_GRID_X_offset = (0x004 + 8);
TCH_GRID_Y_offset = (0x008 + 8);
TCH_VEL_X_offset = (0x00C + 8);
TCH_VEL_Y_offset = (0x010 + 8);

MAG_ENC1_ABS_bytes = response_packet(MAG_ENC1_ABS_offset:MAG_ENC1_ABS_offset + 1);
MAG_ENC1_VEL_bytes = response_packet(MAG_ENC1_VEL_offset:MAG_ENC1_VEL_offset + 3);
MAG_ENC2_ABS_bytes = response_packet(MAG_ENC2_ABS_offset:MAG_ENC2_ABS_offset + 1);
MAG_ENC2_VEL_bytes = response_packet(MAG_ENC2_VEL_offset:MAG_ENC2_VEL_offset + 3);
TCH_GRID_X_bytes = response_packet(TCH_GRID_X_offset:TCH_GRID_X_offset + 3);
TCH_GRID_Y_bytes = response_packet(TCH_GRID_Y_offset:TCH_GRID_Y_offset + 3);
TCH_VEL_X_bytes = response_packet(TCH_VEL_X_offset:TCH_VEL_X_offset + 3);
TCH_VEL_Y_bytes = response_packet(TCH_VEL_Y_offset:TCH_VEL_Y_offset + 3);

MAG_ENC1_ABS = typecast(MAG_ENC1_ABS_bytes, "uint16");
MAG_ENC1_VEL = typecast(MAG_ENC1_VEL_bytes, "single");
MAG_ENC2_ABS = typecast(MAG_ENC2_ABS_bytes, "uint16");
MAG_ENC2_VEL = typecast(MAG_ENC2_VEL_bytes, "single");
TCH_GRID_X = typecast(TCH_GRID_X_bytes, "single");
TCH_GRID_Y = typecast(TCH_GRID_Y_bytes, "single");
TCH_VEL_X = typecast(TCH_VEL_X_bytes, "single");
TCH_VEL_Y = typecast(TCH_VEL_Y_bytes, "single");

end
