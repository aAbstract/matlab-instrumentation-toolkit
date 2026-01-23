function [hal_status, level] = LT_PA105_Get_Level()

arguments (Output)
    hal_status (1, 1) int16
    level (1, 1) single
end

coder.extrinsic("read", "write", "get");

hal_status = int16(-1);
level = single(-1);

persistent is_wating
if isempty(is_wating)
    is_wating = false;
end

if coder.target("MATLAB") || coder.target("Sfun")
    conf = Get_Conf();
    ltbus_device = ML_Get_Device_Port();
    
    if ~is_wating
        packet_size = conf.LTBus_packet_size;
        read_request = LTBus_Read_Request(0xD000, packet_size - 10);
        write(ltbus_device, read_request, "uint8");
        is_wating = true;
        return;
    end

    bytes_available = double(0);
    bytes_available = get(ltbus_device, "BytesAvailable");
    if bytes_available > 0
        packet_size = conf.LTBus_packet_size;
        response_packet = uint8(read(ltbus_device, packet_size, "uint8"));
        offset = (0x010 + 8);
        level_bytes = response_packet(offset:offset + 3);
        level = typecast(level_bytes, "single");
        hal_status = int16(0);
        is_wating = false;
    end
else
    hal_status = coder.ceval("HAL_Read_Level", coder.wref(level));
end

end
