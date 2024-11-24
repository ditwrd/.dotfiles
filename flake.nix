{
  description = "Home Manager configuration of dit";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05"; 
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system; # whatever your system name is
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
    in {
      homeConfigurations."dit" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
