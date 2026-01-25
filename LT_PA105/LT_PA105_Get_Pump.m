function pump = LT_PA105_Get_Pump()

arguments (Output)
    pump (1, 1) single
end

coder.extrinsic("read", "write");

pump = single(-1);

if coder.target("MATLAB") || coder.target("Sfun")
    conf = Get_Conf();
    packet_size = conf.LTBus_packet_size;

    ltbus_device = ML_Get_Device_Port();
    read_request = LTBus_Read_Request(0xD000, packet_size - 10);
    write(ltbus_device, read_request, "uint8");
    response_packet = uint8(read(ltbus_device, packet_size, "uint8"));

    offset = (0x05C + 8);
    bytes_ = response_packet(offset:offset + 3);
    pump = typecast(bytes_, "single");
else
    pump = coder.ceval("HAL_Read_Pump");
end

end
