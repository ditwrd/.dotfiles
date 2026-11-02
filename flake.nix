{
  description = "Home Manager configuration of dit";

  inputs = {
    nixpkgs-master.url = "github:NixOs/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOs/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
    nixpkgs.follows = "nixpkgs-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = {
    nixpkgs,
    sops-nix,
    nixpkgs-stable,
    nixpkgs-master,
    home-manager,
    ...
  }: let
    inherit (nixpkgs) lib;

    pkgsConfig = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    mkPkgs = flake: system:
      import flake {
        inherit system;
        config = pkgsConfig;
      };

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
      pkgs = mkPkgs nixpkgs host.system;
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit (host) username homeDirectory;
          pkgs-stable = mkPkgs nixpkgs-stable host.system;
          pkgs-master = mkPkgs nixpkgs-master host.system;
          inherit sops-nix;
        };
        modules =
          [
            ./config/alias.nix
            ./config/home.nix
            ./config/package.nix
            ./config/programs.nix
            ./config/services.nix
            ./config/ssh.nix
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
