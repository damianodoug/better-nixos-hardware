{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  config = mkIf (config.${namespace}.cpu.amd.enable || config.${namespace}.cpu.intel.enable) {
    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };
    services.fwupd.enable = true; # Enable firmware updates
  };
}
