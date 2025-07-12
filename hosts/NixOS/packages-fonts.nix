# 💫 https://github.com/JaKooLit 💫 #
# Packages and Fonts config including the "programs" options

{ pkgs, inputs, ... }: let

  python-packages = pkgs.python3.withPackages (ps:
    with ps; [
      pip
      black
      isort
      requests
      pyquery # needed for hyprland-dots Weather script
    ]
  );

in {

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # System Packages
    bc
    baobab
    btrfs-progs
    clang
    curl
    cpufrequtils
    duf
    findutils
    ffmpeg
    glib # for gsettings to work
    gsettings-qt
    git
    killall
    libappindicator
    libnotify
    openssl
    pciutils
    wget
    xdg-user-dirs
    xdg-utils

    fastfetch
    (mpv.override { scripts = [ mpvScripts.mpris ]; })

    # Music Player
    kdePackages.elisa

    # Multimedia Apps
    google-chrome
    gimp3-with-plugins
    inkscape-with-extensions
    kdePackages.kdenlive
    handbrake
    audacity

    # Data Manager
    keepassxc

    # Games
    pcsx2
    ppsspp
    gzdoom
    dolphin-emu
    mcpelauncher-ui-qt
    heroic

    # Office
    libreoffice-fresh
    zotero
    anytype
    vscode-fhs

    # Social Media
    telegram-desktop
    discord

    # Wine
    wineWowPackages.stable
    winetricks

    # Graphics Tools
    vulkan-tools
    mesa-demos
    libva-utils
    intel-compute-runtime-legacy1

    # Tools
    johnny
    usbutils
    evtest
    libinput
    mangohud
    protonup-qt
    wireshark

    # Programming Tools
    gh
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
    lzip

    # LabWC Environment
    ags_1
    btop
    swaybg
    swayidle
    mpvpaper
    wlopm
    swaylock-effects
    libheif
    brightnessctl
    cava
    cliphist
    loupe
    gnome-system-monitor
    grim
    gtk-engine-murrine
    imagemagick 
    inxi
    jq
    kitty
    libsForQt5.qtstyleplugin-kvantum
    kanshi
    labwc-tweaks-gtk
    labwc-tweaks
    wdisplays
    networkmanagerapplet
    nvtopPackages.intel
    pamixer
    pavucontrol
    playerctl
    polkit_gnome
    libsForQt5.qt5ct
    kdePackages.qt6ct
    kdePackages.qtwayland
    kdePackages.qtstyleplugin-kvantum
    rofi-wayland
    slurp
    swappy
    swaynotificationcenter
    swww 
    unzip
    p7zip
    unrar
    wallust
    wl-clipboard
    wlogout
    file-roller
    yad
    yt-dlp
    wlr-randr
    inputs.waybar-ext.packages.${pkgs.system}.default
    # Python Packages
    python-packages
  ];

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    corefonts
    fira-code
    noto-fonts-cjk-sans
    jetbrains-mono
    font-awesome
    terminus_font
    victor-mono
    nerd-fonts.jetbrains-mono 
    nerd-fonts.fira-code
    nerd-fonts.fantasque-sans-mono
  ];

  programs = {
    labwc.enable = true;
    firefox.enable = true;
    git.enable = true;
    neovim.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        exo
        mousepad
        thunar-archive-plugin
        thunar-volman
        tumbler
      ];
    };
    virt-manager.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    
    wireshark = {
      enable = true;
      dumpcap.enable = true;
      usbmon.enable = true;
    };

    obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.wlrobs
        pkgs.obs-studio-plugins.obs-vkcapture
      ];
    };

    xwayland.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-wlr
    ];
  };
}
