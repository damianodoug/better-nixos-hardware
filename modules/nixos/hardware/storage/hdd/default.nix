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
  cfg = config.${namespace}.hdd;
in {
  options.${namespace}.hdd = with types; {enable = mkBoolOpt false "Enable module";};

  config = mkIf cfg.enable {
    services.hdapsd.enable = true;
  };
}
