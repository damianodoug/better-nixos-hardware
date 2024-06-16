{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.gpu.amd;
in {
  options.${namespace}.gpu.amd = with types; {
    enable = mkBoolOpt false "Enable module";

    sea-islands = mkBoolOpt false "Enable module";
    southern-islands = mkBoolOpt false "Enable module";
    aka-polaris = mkBoolOpt false "Enable module";
  };

  config = mkIf cfg.enable {
    boot = {
      # Make the kernel use the correct driver early
      initrd.kernelModules = ["amdgpu"];
      kernelParams = [
        # Enable Southern Islands (SI) and Sea Islands (CIK) support
        (mkIf cfg.sea-islands "radeon.cik_support=0")
        (mkIf cfg.sea-islands "amdgpu.cik_support=1")

        (mkIf cfg.southern-islands "radeon.si_support=0")
        (mkIf cfg.southern-islands "amdgpu.si_support=1")
      ];
    };

    # Make sure Xserver uses the `amdgpu` driver
    services.xserver.videoDrivers = ["amdgpu"];

    # Most software has the HIP libraries hard-coded. You can work around it on NixOS by using:
    systemd.tmpfiles.rules = ["L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"];

    hardware.opengl = {
      # For 64 bit applications
      extraPackages = with pkgs; [
        rocmPackages.clr.icd # Enable OpenCL Support
        amdvlk # The AMDVLK drivers can be used in addition to the Mesa RADV drivers, the program will choose which one to use
      ];
      # For 32 bit applications
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk # The AMDVLK drivers can be used in addition to the Mesa RADV drivers, the program will choose which one to use
      ];
    };

    # As of ROCm 4.5, AMD has disabled OpenCL on Polaris based cards. This can be re-enabled by setting
    environment.variables = mkIf cfg.aka-polaris {
      ROC_ENABLE_PRE_VEGA = "1";
    };
  };
}
