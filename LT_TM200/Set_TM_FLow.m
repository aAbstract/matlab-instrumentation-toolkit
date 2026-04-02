function Set_TM_FLow(Flow)

arguments (Input)
    Flow (1, 1) single
end

coder.extrinsic("write");

ltbus_device = ML_Get_Device_Port();
ltbus_write_request = LTBus_Write_F32_Request(0xD006, Flow);
write(ltbus_device, ltbus_write_request, "uint8");

end
