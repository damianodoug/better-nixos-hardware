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
  config = mkIf (config.${namespace}.gpu.amd.enable || config.${namespace}.gpu.intel.enable || config.${namespace}.gpu.nvidia.enable) {
    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      # Enable Vulkan
      driSupport = true; # For 64 bit applications
      driSupport32Bit = true; # For 32 bit applications
    };

    environment.systemPackages = with pkgs; [
      vulkan-tools # Khronos official Vulkan Tools and Utilities
      clinfo # Print all known information about all available OpenCL platforms and devices in the system
      nvtop # A (h)top like task monitor for AMD, Adreno, Intel and NVIDIA GPUs
      glxinfo # Test utilities for OpenGL
    ];
  };
}
