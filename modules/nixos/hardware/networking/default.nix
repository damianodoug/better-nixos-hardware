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
  cfg = config.${namespace}.networking;
in {
  options.${namespace}.networking = with types; {enable = mkBoolOpt false "Enable module";};

  config = mkIf cfg.enable {
    networking = {
      useDHCP = false; # Disable DHCP
      enableIPv6 = false; # Disable IPv6
      networkmanager = {
        enable = true; # Enable NetworkManager
        wifi = {
          macAddress = "random"; # Randomize MAC address
          backend = "iwd"; # Use iwd backend
          scanRandMacAddress = true; # Randomize MAC address during scanning
        };
        ethernet.macAddress = "random"; # Randomize MAC address
        insertNameservers = ["1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"]; # DNS servers
        connectionConfig = ''
          ipv4.dhcp-send-hostname=false
          ipv6.dhcp-send-hostname=false
          ipv6.ip6-privacy=2
        '';
        settings = ''
          [connectivity]
          enabled=false

          [Network]
          IPv6PrivacyExtensions='yes'
        '';
      };
    };
  };
}
