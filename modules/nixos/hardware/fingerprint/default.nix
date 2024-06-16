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
  cfg = config.${namespace}.fingerprint;
in {
  options.${namespace}.fingerprint = with types; {enable = mkBoolOpt false "Enable module";};

  config = mkIf cfg.enable {
    # Enable fingerprint Support
    services.fprintd.enable = true;
  };
}
