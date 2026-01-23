addpath("src");

codegen_config = coder.config("lib", "ecoder", false);
codegen_config.SaturateOnIntegerOverflow = false;
codegen_config.GenerateReport = true;

% supported platforms
% codegen_config.CustomInclude = "platforms/stm32/Inc";

% fullfile(matlabroot, "extern", "include", "tmwtypes.h");
% codegen fft_1024 -config codegen_config;

codegen LTBus_Request -config codegen_config;
