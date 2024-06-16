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
  cfg = config.${namespace}.cpu.intel;
in {
  options.${namespace}.cpu.intel = with types; {
    enable = mkBoolOpt false "Enable module";

    comet-lake = mkBoolOpt false "Enable module";
    elkhart-lake = mkBoolOpt false "Enable module";
    jasper-lake = mkBoolOpt false "Enable module";
    kaby-lake = mkBoolOpt false "Enable module";
    sandy-bridge = mkBoolOpt false "Enable module";
  };

  config = mkIf cfg.enable {
    hardware.cpu.intel.updateMicrocode = true;
    boot.kernelParams = [
      (mkIf cfg.comet-lake "i915.enable_guc=2")

      (mkIf cfg.elkhart-lake "i915.enable_guc=2")

      (mkIf cfg.jasper-lake "i915.enable_guc=2")

      (mkIf cfg.kaby-lake "i915.enable_fbc=1")
      (mkIf cfg.kaby-lake "i915.enable_psr=2")

      (mkIf cfg.sandy-bridge "i915.enable_rc6=7")
    ];
  };
}
