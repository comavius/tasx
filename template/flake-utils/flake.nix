{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    tasx.url = "github:comavius/tasx";
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
      }
    );
}
