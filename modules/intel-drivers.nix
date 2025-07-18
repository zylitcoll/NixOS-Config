# 💫 https://github.com/JaKooLit 💫 #

{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.drivers.intel;
in
{
  options.drivers.intel = {
    enable = mkEnableOption "Enable Intel Graphics Drivers";
  };

  config = mkIf cfg.enable {

    # OpenGL
    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-compute-runtime-legacy1 #opencl
        opencl-headers
        ocl-icd
        intel-media-sdk #QSV
        intel-media-driver #Accelerated Video Playback
        # Vulkan Support
        vulkan-loader        # Loader Vulkan dasar
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
      ];
    };
  };
}
