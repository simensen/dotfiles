{

  description = "Beau's NixOS and MacOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, home-manager, nixpkgs, ... }@inputs: {

    # My Macbook Pro 16"
    darwinConfigurations = {
      "Beaus-m2max-MBP" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./macos
        ];
        inputs = { inherit darwin home-manager nixpkgs; };
      };
    };
  };
}
