{
  description = "Nixos with Hyprland";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, neovim-nightly-overlay, ... }@inputs: {
      nixosConfigurations.hyprnixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.lemuelguevara = import ./home.nix;
              backupFileExtension = "backup";
            };
            nixpkgs.overlays = [ neovim-nightly-overlay.overlays.default ];
          }
        ];
      };
    };
}
