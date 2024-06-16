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
  cfg = config.${namespace}.gpu.nvidia;
in {
  options.${namespace}.gpu.nvidia = with types; {
    enable = mkBoolOpt false "Enable module";

    settings = {
      modesetting = mkBoolOpt true "Enable module";
      powerManagement = mkBoolOpt true "Enable module";
      finegrained = mkBoolOpt false "Enable module";
      open = mkBoolOpt false "Enable module";
      nvidiaSettings = mkBoolOpt true "Enable module";
    };

    package = {
      stable = mkBoolOpt false "Enable module";
      beta = mkBoolOpt false "Enable module";
      production = mkBoolOpt false "Enable module";
      vulkan_beta = mkBoolOpt false "Enable module";

      legacy_470 = mkBoolOpt false "Enable module";
      legacy_390 = mkBoolOpt false "Enable module";
      legacy_340 = mkBoolOpt false "Enable module";
    };

    prime = {
      enable = mkBoolOpt false "Enable module";

      mode = {
        offload = mkBoolOpt false "Enable module";
        sync = mkBoolOpt false "Enable module";
        reverse-sync = {
          enable = mkBoolOpt false "Enable module";
          external-gpu = mkBoolOpt false "Enable module";
        };
      };

      intelBusId = mkOpt str null "e.g PCI:0:2:0";
      nvidiaBusId = mkOpt str null "e.g PCI:14:0:0";
    };
  };

  config = mkIf cfg.enable {
    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = cfg.settings.modesetting;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = cfg.settings.powerManagement;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = cfg.settings.finegrained;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = cfg.settings.open;

      # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
      nvidiaSettings = cfg.settings.nvidiaSettings;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = let
        selectedPackage =
          if cfg.package.stable
          then "stable"
          else if cfg.package.beta
          then "beta"
          else if cfg.package.production
          then "production"
          else if cfg.package.vulkan_beta
          then "vulkan_beta"
          else if cfg.package.legacy_470
          then "legacy_470"
          else if cfg.package.legacy_390
          then "legacy_390"
          else if cfg.package.legacy_340
          then "legacy_340"
          else "stable"; # Default to stable if no other option is selected
      in
        config.boot.kernelPackages.nvidiaPackages.${selectedPackage};

      prime = mkIf cfg.prime.enable {
        offload = {
          enable = cfg.prime.mode.offload;
          enableOffloadCmd = cfg.prime.mode.offload;
        };
        sync.enable = cfg.prime.mode.sync;
        reverseSync.enable = cfg.prime.mode.reverse-sync.enable;
        allowExternalGpu = cfg.prime.mode.reverse-sync.external-gpu;
        # Make sure to use the correct Bus ID values for your system!
        intelBusId = cfg.prime.intelBusId;
        nvidiaBusId = cfg.prime.nvidiaBusId;
      };
    };

    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  };
}
