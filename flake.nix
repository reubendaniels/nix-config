{
  description = "NixOS, macOS and WSL system configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/master";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/reubendaniels/secrets.git";
      flake = false;
    };
  };

  outputs = {nixpkgs, nix-darwin, secrets, ...}@inputs: 
  let
    lib = import ./lib {
      inherit inputs;
      inherit (nixpkgs) lib;
    };
  in
  {
    darwinConfigurations = {
      zod = lib.mkDarwin {
        system = "x86_64-darwin";
        hostname = "zod";
        user = "reuben";
      };
    };

    nixosConfigurations = {
    };
  };
}
