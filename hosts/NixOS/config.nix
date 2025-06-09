# 💫 https://github.com/JaKooLit 💫 #
# Konfigurasi yang telah disederhanakan untuk KDE Plasma 6

{ config, pkgs, host, username, ... }: let
  # Pindahkan variabel ke sini agar file lebih mandiri, atau biarkan jika Anda punya banyak variabel
  keyboardLayout = "gb";
in {
  imports = [
    ./hardware.nix
    ./users.nix
    ./packages-fonts.nix
    ../../modules/intel-drivers.nix
    # ../../modules/local-hardware-clock.nix # Dinonaktifkan di bawah, jadi impor ini tidak perlu
  ];

  # --- BOOT ---
  boot = {
    kernelPackages = pkgs.linuxPackages_zen; # Pilihan kernel Anda, ini bagus.
    #kernelPackages = pkgs.linuxPackages_latest; # Alternatif standar

    kernelParams = [
      "nowatchdog"
      "modprobe.blacklist=iTCO_wdt" # Watchdog untuk Intel, bagus untuk dinonaktifkan
      # "systemd.mask=dev-tpmrm0.device" # Opsional, coba hapus. Mungkin bug lama yang sudah teratasi.
    ];

    # Pengaturan untuk game, bagus untuk dipertahankan.
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
      "vm.dirty_bytes" = 1048576;
      "vm.dirty_background_bytes" = 512000;
    };

    # Bootloader SystemD
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 5;

    # Direkomendasikan untuk performa dan mengurangi beban tulis pada SSD.
    tmp.useTmpfs = true;
    tmp.tmpfsSize = "30%";

    # Dukungan AppImage
    binfmt.registrations.appimage.interpreter = "${pkgs.appimage-run}/bin/appimage-run";

    # Plymouth (Boot Splash)
    plymouth.enable = true;
  };

  # --- JARINGAN & WAKTU ---
  networking.networkmanager.enable = true;
  networking.hostName = "${host}";
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";
  # i18n.extraLocaleSettings tidak perlu jika isinya sama dengan defaultLocale

  # --- DESKTOP ENVIRONMENT (KDE PLASMA 6) ---
  services = {
    # Modul plasma6 akan secara otomatis mengelola xserver dan xwayland.
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true; # Mengaktifkan sesi Wayland di SDDM
    desktopManager.plasma6.enable = true;

    # Sound System Modern
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    security.rtkit.enable = true; # Penting untuk Pipewire

    # Layanan Pendukung Desktop
    devmon.enable = true;         # Otomatis me-mount media eksternal
    gvfs.enable = true;           # Penting untuk filesystem virtual
    tumbler.enable = true;        # Thumbnail untuk file manager
    fstrim.enable = true;         # Penting untuk kesehatan SSD
    upower.enable = true;         # Dikelola oleh Plasma, tapi eksplisit tidak masalah
    libinput.enable = true;       # Input driver untuk Wayland
    gnome.gnome-keyring.enable = true; # Untuk kompatibilitas beberapa aplikasi
  };

  # --- PERANGKAT KERAS ---
  hardware = {
    # Pengaturan Bluetooth, sudah benar. Plasma punya integrasi sendiri.
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
    # OpenGL / Graphics Drivers
    graphics.enable = true;
  };
  services.fwupd.enable = true; # Untuk update firmware perangkat

  # --- LAYANAN OPSIONAL (SESUAI KEBUTUHAN ANDA) ---
  services = {
    openssh.enable = true;           # Jika Anda butuh akses SSH ke mesin ini
    printing.enable = true;        # Jika Anda menggunakan printer
    flatpak.enable = false;         # Diaktifkan agar konfigurasi remote di bawah berfungsi
  };

  # Cara yang benar untuk menambahkan remote Flatpak
  services.flatpak.remotes = [
    { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
  ];

  # --- Keamanan ---
  security.polkit.enable = true;
  # Aturan polkit ini sudah bagus, memungkinkan reboot/shutdown tanpa password.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
  
  # --- PENGATURAN NIX & OPTIMISASI ---
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      # DIHAPUS: Repositori cachix Hyprland tidak relevan untuk KDE Plasma
      # substituters = [ "https://hyprland.cachix.org" ];
      # trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # --- VIRTUALISASI (SIMPAN JIKA ANDA MENGGUNAKANNYA) ---
  virtualisation = {
    libvirtd.enable = true;
    waydroid.enable = true;
    docker = {
      enable = true;
      enableOnBoot = true;
      extraPackages = with pkgs; [
        docker-compose  # Pastikan docker-compose ada di sini
      ];
    };
  };
  # --- DATABASE (SIMPAN JIKA ANDA MENGGUNAKANNYA) ---
  # services.mongodb = {
  #   enable = true;
  #   ...
  # };

  # --- LAIN-LAIN ---
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "schedutil"; # Pilihan yang bagus
  zramSwap.enable = true; # Sangat direkomendasikan
  console.keyMap = "uk";
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Bagus untuk aplikasi Electron
  
  # DIHAPUS: Variabel di bawah ini spesifik untuk Hyprland atau merupakan anti-pattern.
  # environment.sessionVariables.QML_IMPORT_PATH = ...
  # environment.sessionVariables.LD_LIBRARY_PATH = ...

  system.stateVersion = "25.05";
}
