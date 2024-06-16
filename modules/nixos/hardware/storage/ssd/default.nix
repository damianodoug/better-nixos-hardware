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
  cfg = config.${namespace}.ssd;
in {
  options.${namespace}.ssd = with types; {enable = mkBoolOpt false "Enable module";};

  config = mkIf cfg.enable {
    services.fstrim = {
      enable = true; # Enable SSD TRIM
      interval = "weekly"; # Set TRIM interval
    };
  };
}
