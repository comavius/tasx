{flake-parts-lib, ...}: let
in {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    pkgs,
    lib,
    ...
  }: {
    options.tasx = import ./options.nix {inherit pkgs lib;};
  });

  config.perSystem = {
    pkgs,
    lib,
    config,
    ...
  }: let
    mkTaskApps = pkgs.callPackage (import ./mkTaskApps) {};
  in
    lib.mkIf config.tasx.enable {
      apps = mkTaskApps config.tasx;
    };
}
