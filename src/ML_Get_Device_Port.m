function port = ML_Get_Device_Port()

persistent device_port

coder.extrinsic("serialport");

if isempty(device_port)
    conf = Get_Conf();
    device_port = serialport(conf.LTBus_device_port, conf.LTBus_baud_rate);
end

port = device_port;

end
