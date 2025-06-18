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
    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };

    # OpenGL
    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
        libva
        intel-media-sdk       #  SDK untuk Intel Quick Sync (diperlukan OBS Studio/QSV encoder)
        # Vulkan Support
        vulkan-loader        # Loader Vulkan dasar
      ];
    };
  };
}
