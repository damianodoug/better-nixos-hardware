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
  cfg = config.${namespace}.cpu.amd;
in {
  options.${namespace}.cpu.amd = with types; {enable = mkBoolOpt false "Enable module";};

  config = mkIf cfg.enable {
    hardware.cpu.amd.updateMicrocode = true;
  };
}
