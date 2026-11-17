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
      "darwin-work" = {
        system = "aarch64-darwin";
        username = "aditya.wardianto";
        homeDirectory = "/Users/aditya.wardianto";
      };
    };

    mkHome = attrName: host: let
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
          inherit sops-nix attrName;
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
      dit = mkHome "dit" hosts.linux;
      "dit@mac" = mkHome "dit@mac" hosts.darwin;
      "aditya.wardianto" = mkHome "aditya.wardianto" hosts."darwin-work";
    };
  };
}
