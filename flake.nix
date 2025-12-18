{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...}: let
    # https://nix.dev/manual/nix/2.25/language/derivations
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "i686-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "armv6l-linux"
      "armv7l-linux"
    ];
    forAllPkgs = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs {inherit system;}));
    cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
  in {
    lib = import ./lib/default.nix;

    packages = forAllPkgs (
      pkgs: {
        default = pkgs.rustPlatform.buildRustPackage {
          pname = cargoToml.package.name;
          version = cargoToml.package.version;
          src = pkgs.lib.fileset.toSource {
            root = ./.;
            fileset = pkgs.lib.fileset.unions [
              ./Cargo.toml
              ./Cargo.lock
              ./app
            ];
          };
          cargoLock.lockFile = ./Cargo.lock;
          meta = with pkgs.lib; {
            description = cargoToml.package.description;
            license = licenses.mit;
            maintainers = cargoToml.package.authors;
          };
        };

        lib = pkgs.callPackage (import ./lib/default.nix) {};
      }
    );
    formatter = forAllPkgs (pkgs: pkgs.alejandra);

    templates = {
      flake-parts = ./examples/flake-parts;
      flake-utils = ./examples/flake-utils;
      json = ./examples/json-conf;
    };
  };
}
