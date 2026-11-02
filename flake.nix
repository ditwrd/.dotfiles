{
  description = "Home Manager configuration of dit";

  inputs = {
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
    nixpkgs.follows = "nixpkgs-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = {
    nixpkgs,
    sops-nix,
    home-manager,
    ...
  }: let
    inherit (nixpkgs) lib;

    hosts = {
      linux = {
        system = "x86_64-linux";
        username = "dit";
        homeDirectory = "/home/dit";
      };
      darwin = {
        system = "aarch64-darwin";
        username = "dit";
        homeDirectory = "/Users/dit";
      };
    };

    mkHome = host: let
      pkgs = import nixpkgs {
        inherit (host) system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit (host) username homeDirectory;
          inherit sops-nix;
        };
        modules =
          [
            ./config/alias.nix
            ./config/home.nix
            ./config/package.nix
            ./config/programs.nix
            ./config/secrets.nix
            ./config/services.nix
            ./config/ssh
          ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            ./config/linux.nix
          ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
            ./config/darwin.nix
          ];
      };
  in {
    homeConfigurations = {
      dit = mkHome hosts.linux;
      "dit@mac" = mkHome hosts.darwin;
    };
  };
}
