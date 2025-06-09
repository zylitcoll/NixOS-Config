# 💫 https://github.com/JaKooLit 💫 #
# Konfigurasi Paket dan Font yang Disederhanakan untuk KDE Plasma

{ pkgs, ... }: let

  # Paket Python, dikelompokkan untuk kerapian.
  python-packages = pkgs.python3.withPackages (
    ps:
      with ps; [
        # DIHAPUS: Menginstal 'pip' secara deklaratif adalah anti-pattern di NixOS.
        # Carilah paket Nix untuk library yang Anda butuhkan.
        # pip
        black     # Untuk developer Python
        isort     # Untuk developer Python
        requests
        # DIHAPUS: 'pyquery' untuk skrip cuaca Hyprland tidak diperlukan di KDE.
      ]
  );

in {
  # Mengizinkan instalasi paket non-free seperti Google Chrome, Discord, Steam, dll.
  nixpkgs.config.allowUnfree = true;

  # --- DAFTAR PAKET SISTEM ---
  environment.systemPackages = with pkgs; [
    # ---------------- Utilitas Dasar & Penting ----------------
    # Sebagian besar utilitas baris perintah dasar (find, curl, wget, dll.) sudah
    # termasuk dalam sistem dasar atau ditarik sebagai dependensi.
    # Kita hanya perlu menambahkan beberapa yang benar-benar berguna untuk desktop.
    gsettings-qt      # Sangat direkomendasikan untuk integrasi tema aplikasi GTK
    libappindicator   # Penting untuk ikon system tray aplikasi pihak ketiga
    btop              # Monitor sistem yang canggih
    fastfetch         # Informasi sistem di terminal
    #kdePackages.filelight         # Alternatif KDE untuk Baobab, untuk analisis disk
    yt-dlp            # Mengunduh video dari YouTube dan situs lain
    libheif           # Dukungan untuk format gambar HEIF/HEIC (dari iPhone)
    (mpv.override { scripts = [ mpvScripts.mpris ]; }) # MPV dengan kontrol media

    # ---------------- Aplikasi Desktop & Multimedia ----------------
    google-chrome     # Alternatif untuk Firefox
    gimp-with-plugins
    inkscape-with-extensions
    kdePackages.kdenlive  # Editor video yang terintegrasi baik dengan KDE
    handbrake
    obs-studio
    keepassxc
    libreoffice-fresh
    zotero
    anytype
    telegram-desktop
    discord
    kitty             # Terminal emulator, alternatif untuk Konsole

    # ---------------- Gaming & Emulator ----------------
    pcsx2
    ppsspp
    gzdoom
    dolphin-emu
    mcpelauncher-ui-qt
    heroic
    wineWowPackages.stable # Wine untuk aplikasi 32-bit dan 64-bit
    winetricks

    # ---------------- Alat Grafis & Diagnostik ----------------
    vulkan-tools
    mesa-demos
    libva-utils

    # ---------------- Alat Pengembangan (sesuai kebutuhan Anda) ----------------
    gh                # GitHub CLI
    jdk21_headless
    nodejs_24
    nodePackages_latest.prettier
    pnpm_10
    php
    php82Packages.composer
    lua
    stylua
    android-tools
    mongodb-compass
    johnny            # GUI untuk John the Ripper

    # Menambahkan grup paket Python yang kita definisikan di atas
    python-packages

  ];

  # --- FONTS ---
  # Daftar font Anda sudah sangat bagus, tidak ada yang perlu dihapus.
  fonts.packages = with pkgs; [
    # Dasar & UI
    noto-fonts
    noto-fonts-cjk-sans
    font-awesome
    corefonts # Font Microsoft untuk kompatibilitas web

    # Programming & Terminal
    nerd-fonts.jetbrains-mono 
    nerd-fonts.fira-code
    nerd-fonts.fantasque-sans-mono
    victor-mono
    terminus_font
  ];

  # --- PENGATURAN PROGRAM & LAYANAN ---
  programs = {
    firefox.enable = true;
    git.enable = true; 
    neovim.enable = true;
    virt-manager.enable = true; # GUI untuk mengelola mesin virtual
    dconf.enable = true;      # Penting untuk aplikasi GTK
    mtr.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    
    # DIHAPUS: xwayland.enable = true; ini sudah diurus oleh modul KDE Plasma 6 secara otomatis.
    # DIHAPUS: seahorse adalah alat GNOME. KDE punya KGpg/KWallet, tetapi bisa diinstal jika Anda lebih suka.
    # seahorse.enable = true;
  };

  # --- XDG DESKTOP PORTAL ---
  # Konfigurasi ini penting untuk aplikasi Flatpak dan screen sharing di Wayland.
  xdg.portal = {
    enable = true;
    # Modul KDE sudah memilih backend portal yang benar (kde, gtk).
    # Opsi di bawah ini adalah cara eksplisit untuk memastikan portal gtk ada.
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    # DIHAPUS: configPackages adalah opsi yang sudah usang dan tidak berpengaruh.
    # DIHAPUS: wlr.enable tidak relevan untuk KDE.
  };
}
