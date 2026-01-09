{
  description = "Nixos with Hyprland";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, chaotic, home-manager
    , neovim-nightly-overlay, ... }: {
      nixosConfigurations.hyprnixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./nixModules/system/configuration.nix
          chaotic.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.lemuelguevara = import ./nixModules/home/home.nix;
              backupFileExtension = "backup";
            };
            nixpkgs.overlays = [ neovim-nightly-overlay.overlays.default ];
          }
        ];
      };
    };
}
