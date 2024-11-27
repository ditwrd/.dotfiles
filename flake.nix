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

  outputs = { nixpkgs, sops-nix, nixpkgs-stable, nixpkgs-master, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
      pkgs-master = import nixpkgs-master {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
    in
    {
      homeConfigurations."dit" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit pkgs-stable pkgs-master sops-nix;
        };

        modules = [
          ./config/alias.nix
          ./config/home.nix
          ./config/package.nix
          ./config/programs.nix
          ./config/services.nix
          ./config/ssh.nix
        ];

      };
    };
}
