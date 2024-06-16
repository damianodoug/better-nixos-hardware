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
  cfg = config.${namespace}.battery;
in {
  options.${namespace}.battery = with types; {enable = mkBoolOpt false "Enable module";};

  config = mkIf config.archtypes.desktop.laptop {
    # power management tool which allows for managing hibernate and suspend states
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };
    services = {
      # Automatic CPU speed & power optimizer for Linux
      auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
          };
          charger = {
            governor = "performance";
            turbo = "auto";
          };
        };
      };
      # Better scheduling for CPU cycles
      system76-scheduler.settings.cfsProfiles.enable = true;
      # Prevents overheating on Intel CPUs and works well with other tools
      thermald.enable = config.${namespace}.hardware.cpu.intel.enable;
      # Disable GNOMEs power management
      power-profiles-daemon.enable = mkDefault false;
    };
  };
}
