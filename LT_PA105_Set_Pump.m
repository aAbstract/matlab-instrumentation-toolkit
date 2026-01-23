function LT_PA105_Set_Pump(pump)

arguments (Input)
    pump (1, 1) single
end

coder.extrinsic("write");

if coder.target("MATLAB") || coder.target("Sfun")
    ltbus_device = ML_Get_Device_Port();
    ltbus_write_request = LTBus_Write_F32_Request(0xD05C, 4);
    write(ltbus_device, ltbus_write_request, "uint8");
else
    coder.ceval("HAL_Set_Pump", pump);
end

end
