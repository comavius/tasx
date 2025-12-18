{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # replace inputs.tasx.url with "github:comavius/tasx"
    tasx.url = "file://../../../";
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
