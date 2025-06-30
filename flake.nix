# This configuration is based on https://github.com/JaKooLit/NixOS-Hyprland
# Modified by @zylitcoll for personal daily use.
{
  description = "My-NixOS";
  inputs = {
	  nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    waybar-ext.url ="github:jp7677/Waybar/ext-workspaces";
	  #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	  #distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
  };

  outputs =
	inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      host = "NixOS";
      username = "why";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    in
      {
	nixosConfigurations = {
      "${host}" = nixpkgs.lib.nixosSystem rec {
		specialArgs = {
			inherit system;
			inherit inputs;
			inherit username;
			inherit host;
			};
	  modules = [
			./hosts/${host}/config.nix 
			# inputs.distro-grub-themes.nixosModules.${system}.default
			];
			};
		};
	};
}
