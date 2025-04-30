
Run this command to ensure git, curl, vim & pciutils are installed: Note: or nano if you prefer nano for editing

    nix-shell -p git vim curl pciutils

Clone this repo & CD into it:

    git clone --depth 1 https://github.com/zylitcoll/NixOS-Config.git ~/NixOS-Config
    cd ~/NixOS-Config

You should stay in this directory for the rest of the install
Create the host directory for your machine(s)

cp -r hosts/default hosts/<your-desired-hostname>

    
Edit as required the config.nix , packages-fonts.nix and/or users.nix in hosts/<your-desired-hostname>/
then generate your hardware.nix with:

    sudo nixos-generate-config --show-hardware-config > hosts/<your-desired-hostname>/hardware.nix

Run this to enable flakes and install the flake replacing hostname with whatever you put as the hostname:

    NIX_CONFIG="experimental-features = nix-command flakes" 
    
    sudo nixos-rebuild switch --flake .#hostname
