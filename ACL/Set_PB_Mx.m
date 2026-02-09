function Set_PB_Mx(M1_DIR_PWM, M2_DIR_PWM)

arguments (Input)
    M1_DIR_PWM (1, 1) int16
    M2_DIR_PWM (1, 1) int16
end

coder.extrinsic("write");

ltbus_device = ML_Get_Device_Port();

ltbus_write_request = LTBus_Write_I16_Request(0xD080, M1_DIR_PWM);
write(ltbus_device, ltbus_write_request, "uint8");

ltbus_write_request = LTBus_Write_I16_Request(0xD082, M2_DIR_PWM);
write(ltbus_device, ltbus_write_request, "uint8");

end
