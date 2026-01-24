{
  description = "KyujinNixOS - flake";

  inputs = {
    # Stable for system
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    
    # Unstable for specific packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";  # Follow stable for home-manager
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";  # Use unstable for spicetify
    };

    ambxst = {
      url = "github:Axenide/Ambxst";
      inputs.nixpkgs.follows = "nixpkgs-unstable";  # Use unstable for ambxst
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, spicetify-nix, ambxst, ... }:
  let
    system = "x86_64-linux";

    # Import package sets
    pkgs = import nixpkgs { inherit system; };
    unstable = import nixpkgs-unstable { inherit system; };

    # spicetify packages from unstable
    spicePkgs = spicetify-nix.legacyPackages.${system};
    
  in
  {
    nixosConfigurations.KyujinNixOS = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs ambxst spicePkgs;
        inherit unstable;  # Pass unstable package set to modules
      };

      modules = [
        # Global nixpkgs configuration (using stable)
        {
          nixpkgs.config.allowUnfree = true;
        }

        # Base system (uses stable)
        ./nixos/configuration.nix

        # Home Manager as NixOS module (uses stable via follows)
        home-manager.nixosModules.home-manager

        # Home Manager configuration
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = {
            inherit spicePkgs unstable;  # Pass unstable to home-manager
          };

          home-manager.users.luwiblu = {
            imports = [
              ./home.nix
              spicetify-nix.homeManagerModules.spicetify
            ];
          };
        }

        # Your custom modules
        ./nixos/modules/ambxst.nix
        ./nixos/modules/hyprland.nix
        ./nixos/modules/lazyvim.nix
      ];
    };
  };
}
