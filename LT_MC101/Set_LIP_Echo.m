function Set_LIP_Echo(value)

arguments (Input)
    value (1, 1) single
end

coder.extrinsic("write");

ltbus_device = ML_Get_Device_Port();
ltbus_write_request = LTBus_Write_F32_Request(0xD086, value);
write(ltbus_device, ltbus_write_request, "uint8");

end
