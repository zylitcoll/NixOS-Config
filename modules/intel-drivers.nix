# 💫 https://github.com/JaKooLit 💫 #
# Modul driver Intel yang disederhanakan

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
    # Override ini diperlukan untuk mengaktifkan codec hybrid pada driver VAAPI,
    # terutama untuk GPU Intel Arc. Ini sudah benar.
    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };

    # Mengaktifkan driver OpenGL/Vulkan dasar. NixOS akan mendeteksi Intel secara otomatis.
    hardware.graphics.enable = true;

    # Kita hanya menambahkan paket EKSTRA yang mungkin tidak diinstal secara default.
    hardware.graphics.extraPackages = with pkgs; [
      # Driver utama 'intel-media-driver' dan 'vulkan-loader' sudah diurus oleh `hardware.graphics.enable = true`.
      
      # Kompatibilitas untuk aplikasi yang menggunakan VDPAU (alternatif VA-API).
      libvdpau-va-gl

      # Diperlukan untuk encoding Intel Quick Sync (QSV) di aplikasi seperti OBS Studio.
      intel-media-sdk

      # Diperlukan untuk dukungan OpenCL (komputasi GPGPU).
      intel-compute-runtime
    ];
  };
}
