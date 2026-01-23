{
  description = "KyujinNixOS - flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    ambxst.url = "github:Axenide/Ambxst";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, spicetify-nix, ambxst, ... }:
  let
    system = "x86_64-linux";

    # system-specific spicetify packages (NOT pkgs-based, avoids recursion)
    spicePkgs = spicetify-nix.legacyPackages.${system};
  in
  {
    nixosConfigurations.KyujinNixOS = nixpkgs.lib.nixosSystem {
      inherit system;

      # only pass what NixOS cannot derive itself
      specialArgs = {
        inherit inputs ambxst spicePkgs;
      };

      modules = [
        # global nixpkgs configuration (SAFE)
        {
          nixpkgs.config.allowUnfree = true;
        }

        # base system
        ./nixos/configuration.nix

        # Home Manager as NixOS module
        home-manager.nixosModules.home-manager

        # Home Manager configuration
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = {
            inherit spicePkgs;
          };

          home-manager.users.luwiblu = {
            imports = [
              ./home.nix
              spicetify-nix.homeManagerModules.spicetify
            ];
          };
        }

        # your custom modules
        ./nixos/modules/ambxst.nix
        ./nixos/modules/hyprland.nix
        ./nixos/modules/lazyvim.nix
      ];
    };
  };
}

