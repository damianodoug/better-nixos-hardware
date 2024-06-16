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
  cfg = config.${namespace}.gpu.intel;
in {
  options.${namespace}.gpu.intel = with types; {
    enable = mkBoolOpt false "Enable module";
    alder-lake = {
      enable = mkBoolOpt false "Enable module";
      id = mkOpt str null "00:02.0 VGA compatible controller [0300]: Intel Corporation Alder Lake-UP3 GT2 [Iris Xe Graphics] [8086:{HERE}] (rev 0c)";
    };
  };

  config = mkIf cfg.enable {
    # Make sure Xserver uses the `intel` driver
    services.xserver.videoDrivers = ["intel"];
    # Make the kernel use the correct driver early

    boot.initrd.kernelModules = [
      (
        if cfg.alder-lake.enable
        then "i915.force_probe=${cfg.alder-lake.id}"
        else "i915"
      )
    ];

    hardware.opengl = {
      # For 64 bit applications
      extraPackages = with pkgs; [
        intel-media-driver # Intel Media Driver for VAAPI — Broadwell+ iGPUs
        libvdpau-va-gl # VDPAU driver with OpenGL/VAAPI backend
      ];
      # For 32 bit applications
      extraPackages32 = with pkgs.driversi686Linux; [
        intel-media-driver # Intel Media Driver for VAAPI — Broadwell+ iGPUs
        libvdpau-va-gl # VDPAU driver with OpenGL/VAAPI backend
      ];
    };
    # Force intel-media-driver
    environment.sessionVariables.LIBVA_DRIVER_NAME = mkForce "iHD";
  };
}
