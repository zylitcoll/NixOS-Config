

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
			  libva-utils
        #intel-media-sdk       #  SDK untuk Intel Quick Sync (diperlukan OBS Studio/QSV encoder)
        intel-compute-runtime #  OpenCL support (untuk komputasi GPU/machine learning)
        # Vulkan Support
        vulkan-loader        # Loader Vulkan dasar
        vulkan-validation-layers  # Tools debugging (opsional)

      ];

      # Dukungan 32-bit (untuk aplikasi seperti Wine/Steam)
      extraPackages32 = with pkgs.pkgsi686Linux; [ 
        libva  # VA-API versi 32-bit
      ];
    };

    # 🔧 Variabel environment kritis
    # environment.variables = {
    #   LIBVA_DRIVER_NAME = "iHD";  # 🖥️ Paksa pakai driver Intel modern ("iHD" untuk Gen 8+, "i965" untuk Gen 4-7)
    #   VDPAU_DRIVER = "va_gl";     # 🎮 Gunakan VA-API sebagai backend VDPAU (untuk game/aplikasi berbasis VDPAU)
    # };

  };
}
