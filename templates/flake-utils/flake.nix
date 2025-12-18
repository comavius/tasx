{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    tasx.url = "github:comavius/tasx";
    tasx.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    tasx,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        tasxConf = import ./tasx.nix;
      in {
        apps = tasx.lib.mkApps {
          inherit pkgs tasxConf;
        };
        devShells.default = pkgs.mkShell {
          buildInputs = [tasx.packages."${system}".default];
        };
      }
    );
}
