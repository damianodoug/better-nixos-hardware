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
  config = mkIf (config.${namespace}.ssd.enable || config.${namespace}.hdd.enable) {
    boot.supportedFilesystems = ["ntfs"]; # Enable NTFS support at boot
    # Enable smartd for HDD/SSD health monitoring
    services.smartd = {
      enable = true;
      autodetect = true; # Autodetect drives
    };
  };
}
