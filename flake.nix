{
  description = "My-NixOS";
  inputs = {
	nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  	#nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  unstable.url = "github:NixOS/nixpkgs/nixos-unstable";  # untuk LibreOffice saja
	
	#hyprland.url = "github:hyprwm/Hyprland"; # hyprland development
	#distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
	ags.url = "github:aylur/ags/v1"; # aylurs-gtk-shell-v1
  	};

  outputs =
	inputs@{ self, nixpkgs, unstable, ... }:
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

    unstablePkgs = import unstable {
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
      inherit unstablePkgs;
			};
	  modules = [
			./hosts/${host}/config.nix 
			# inputs.distro-grub-themes.nixosModules.${system}.default
			];
			};
		};
	};
}
