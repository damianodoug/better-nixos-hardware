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
  cfg = config.${namespace}.audio;
in {
  options.${namespace}.audio = with types; {enable = mkBoolOpt false "Enable module";};

  config = mkIf cfg.enable {
    hardware.pulseaudio.enable = mkForce false; # Disable PulseAudio
    sound.enable = mkForce false; # Disable ALSA-based sound
    security.rtkit.enable = mkForce true; # Enable rtkit for real-time scheduling
    services.pipewire = {
      enable = true; # Enable PipeWire
      alsa.enable = true; # Enable ALSA support
      alsa.support32Bit = true; # Enable 32-bit ALSA support
      pulse.enable = true; # Enable PulseAudio emulation
      jack.enable = true; # Enable JACK emulation
      wireplumber.enable = true; # Enable WirePlumber
    };
  };
}
