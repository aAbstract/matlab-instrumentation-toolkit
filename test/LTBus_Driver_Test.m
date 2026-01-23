classdef LTBus_Driver_Test < matlab.unittest.TestCase
    methods(Test)
        
        function Test_Read_Request(test_case)
            expected_packet = uint8([0x7B, 0x01, 0xAA, 0x04, 0xD0, 0x04, 0x00, 0x7A, 0xD3, 0x7D]); % RFR 0xD004 F32
            read_request = LTBus_Read_Request(0xD004, 4);
            test_case.verifyEqual(read_request, expected_packet);
        end

        function Test_CheckCRC16(test_case)
            packet = uint8([0x7B, 0x01, 0xAB, 0x00, 0xA0, 0x02, 0x00, 0x01, 0x50, 0xA8, 0x7C, 0x7D]);
            is_valid = LTBus_CheckCRC16(packet, 12);
            test_case.verifyEqual(is_valid, true);
        end

        function Test_Write_F32_Request(test_case)
            expected_packet = uint8([0x7B, 0x01, 0xEA, 0x00, 0xD0, 0x04, 0x00, 0xA4, 0x70, 0x45, 0x41, 0xB9, 0xD1, 0x7D]);
            write_request = LTBus_Write_F32_Request(0xD000, 12.34);
            test_case.verifyEqual(write_request, expected_packet);
        end

        function Test_ML_Read_Device_ID(test_case)
            conf = Get_Conf();
            device_id = ML_Read_Device_ID();
            test_case.verifyEqual(device_id, conf.LTBus_device_id);
        end

    end
end
