{
  description = "Home Manager configuration of dit";

  inputs = {
    nixpkgs-master.url = "github:NixOs/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOs/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
    nixpkgs.follows = "nixpkgs-unstable";



    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { nixpkgs, nixpkgs-stable, nixpkgs-master, home-manager, ... }:
    let
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };

      pkgs = import nixpkgs {
        inherit system;
        inherit config;
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        inherit config;
      };
      pkgs-master = import nixpkgs-master {
        inherit system;
        inherit config;
      };
    in
    {
      homeConfigurations."dit" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit pkgs-stable pkgs-master;
        };

        modules = [
          ./src/alias.nix
          ./src/home.nix
          ./src/package.nix
          ./src/programs.nix
          ./src/services.nix
        ];

      };
    };
}
