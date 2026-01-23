function device_id = ML_Read_Device_ID()

arguments (Output)
    device_id (1, 1) uint16
end

coder.extrinsic("read", "write");

ltbus_device = ML_Get_Device_Port();
ltbus_read_request = LTBus_Read_Request(0xA000, 2);
write(ltbus_device, ltbus_read_request, "uint8");

ltbus_read_response = uint8(read(ltbus_device, 12 , "uint8"));
val_u16 = typecast(ltbus_read_response(8:9), "uint16");
device_id = val_u16;
end
