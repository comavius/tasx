{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    tasx.url = "github:comavius/tasx";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    tasx,
  }:
    flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      imports = [
        tasx.lib.flakeModules.default
      ];
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "i686-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "armv6l-linux"
        "armv7l-linux"
      ];
      perSystem = {pkgs, ...}: {
        tasx = import ./tasx.nix {inherit pkgs;};
      };
    });
}
