# 💫 https://github.com/JaKooLit 💫 #
# Packages and Fonts config including the "programs" options

{ pkgs, inputs, ...}: let

  python-packages = pkgs.python3.withPackages (
    ps:
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

  environment.systemPackages = (with pkgs; [
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
    glib #for gsettings to work
    gsettings-qt
    git
    killall
    libappindicator
    libnotify
    openssl #required by Rainbow borders
    pciutils
    wget
    xdg-user-dirs
    xdg-utils

    fastfetch
    (mpv.override {scripts = [mpvScripts.mpris];}) # with tray

    #music player
    kdePackages.elisa

    #aplikasi multimedia
    google-chrome
    gimp3-with-plugins
    inkscape-with-extensions
    kdePackages.kdenlive
    handbrake
    obs-studio
    audacity

    #data manager 
    keepassxc

    #games
    pcsx2
    ppsspp
    gzdoom
    dolphin-emu
    mcpelauncher-ui-qt
    heroic

    #office
    libreoffice-fresh
    zotero
    anytype
    vscode-fhs

    #sosial media 
    telegram-desktop
    discord

    #wine 
    wineWowPackages.stable
    winetricks

    #grafix tool 
    vulkan-tools
    mesa-demos
    libva-utils
    intel-compute-runtime-legacy1

    #tool
    johnny
    usbutils


    #tool bahasa programs
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

    #labwc
    ags
    btop
    swaybg
    swayidle
    wlopm
    swaylock
    libheif
    brightnessctl # for brightness control
    cava
    cliphist
    loupe
    gnome-system-monitor
    grim
    gtk-engine-murrine #for gtk themes
    imagemagick 
    inxi
    jq
    kitty
    libsForQt5.qtstyleplugin-kvantum #kvantum
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
    kdePackages.qtstyleplugin-kvantum #kvantum
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
  ]) ++ [
	  python-packages
  ];

  # FONTS
  fonts.packages = with pkgs; [
    noto-fonts
    corefonts  #msfonts
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
	
	  waybar.enable = true;
	  firefox.enable = true;
	  git.enable = true;
    nm-applet.indicator = true;
    neovim.enable = true;

	  thunar.enable = true;
	  thunar.plugins = with pkgs.xfce; [
		  exo
		  mousepad
		  thunar-archive-plugin
		  thunar-volman
		  tumbler
  	  ];
	
    virt-manager.enable = true;

    steam = {
     enable = true;
     gamescopeSession.enable = true;
     remotePlay.openFirewall = true;
     dedicatedServer.openFirewall = true;
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

  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
  };

}
