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
  cfg = config.${namespace}.printer;
in {
  options.${namespace}.printer = with types; {enable = mkBoolOpt false "Enable module";};

  config = mkIf cfg.enable {
    # Enable priting support
    services.printing.enable = true;
  };
}
