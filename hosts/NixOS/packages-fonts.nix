# Packages and Fonts config including the "programs" options

{ pkgs, inputs, unstablePkgs, ...}: let

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
    mpd
    mpc-cli
    ncmpcpp
    #ranger

    #aplikasi multimedia
    google-chrome
    gimp-with-plugins
    inkscape-with-extensions
    libsForQt5.kdenlive

    #data manager 
    keepassxc

    #office
    unstablePkgs.libreoffice-fresh
    zotero
    anytype

    #sosial media 
    telegram-desktop


    #tool bahasa programs
    gh 
    jdk21_headless
    nodejs_23
    nodePackages_latest.prettier
    pnpm_10
    php 
    php82Packages.composer
    lua
    stylua



         
    # Hyprland Stuff
    #(ags.overrideAttrs (oldAttrs: { inherit (oldAttrs) pname; version = "1.8.2"; }))
    ags # desktop overview  
    btop
    brightnessctl # for brightness control
    cava
    cliphist
    gthumb
    gnome-system-monitor
    grim
    gtk-engine-murrine #for gtk themes
    hypridle
    imagemagick 
    inxi
    jq
    kitty
    libsForQt5.qtstyleplugin-kvantum #kvantum
    networkmanagerapplet
    nwg-displays
    nwg-look
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
    wallust
    wl-clipboard
    wlogout
    file-roller
    yad
    yt-dlp

    #waybar  # if wanted experimental next line
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
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
    (nerdfonts.override {fonts = ["JetBrainsMono"];}) # stable banch
    (nerdfonts.override {fonts = ["FantasqueSansMono"];}) # stable banch
    
    #nerd-fonts.jetbrains-mono # unstable 
    #nerd-fonts.fira-code # unstable
    #nerd-fonts.fantasque-sans-mono #unstable
 	];
  
  programs = {
	  hyprland = {
      enable = true;
     	#package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
		  #portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; #xdph-git
     	portalPackage = pkgs.xdg-desktop-portal-hyprland; # xdph none git
  	  xwayland.enable = true;
    };
   
    obs-studio = {
      enable = true;
      # plugins = with pkgs.obs-studio-plugins; [
      #   # Plugin untuk Wayland (jika digunakan)
        # wlrobs
      #   obs-backgroundremoval
      # 
      #   # Plugin capture untuk Intel
        # obs-vaapi              # VAAPI encoder/decoder untuk Intel iGPU
      #   obs-vkcapture          # Vulkan capture (bisa bekerja dengan Intel)
      # 
      #   # Plugin umum yang berguna
      #   obs-pipewire-audio-capture  # Audio capture via PipeWire
      #   obs-gstreamer              # Dukungan GStreamer
      #   obs-nvfbc                  # Frame Buffer Capture (alternatif)
      # 
      #   # Plugin output/encoding
      #   obs-ndi                   # NDI support
      #   obs-websocket             # Remote control via WebSocket
      # ];
    };


	
	  waybar.enable = true;
	  hyprlock.enable = true;
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
    
    #steam = {
    #  enable = true;
    #  gamescopeSession.enable = true;
    #  remotePlay.openFirewall = true;
    #  dedicatedServer.openFirewall = true;
    #};
    
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


  #Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    extraPackages = with pkgs; [
      docker-compose  # Pastikan docker-compose ada di sini
    ];
  };

  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    };

  
  }
