function clock = LT_PA105_Get_Clock()

arguments (Output)
    clock (1, 1) uint32
end

coder.extrinsic("read", "write");

clock = uint32(-1);

if coder.target("MATLAB") || coder.target("Sfun")
    conf = Get_Conf();
    packet_size = conf.LTBus_packet_size;

    ltbus_device = ML_Get_Device_Port();
    read_request = LTBus_Read_Request(0xD000, packet_size - 10);
    write(ltbus_device, read_request, "uint8");
    response_packet = uint8(read(ltbus_device, packet_size, "uint8"));

    offset = (0x000 + 8);
    clock_bytes = response_packet(offset:offset + 3);
    clock = typecast(clock_bytes, "uint32");
else
    clock = coder.ceval("HAL_Read_Clock");
end

end
