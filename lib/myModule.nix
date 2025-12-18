{
  pkgs,
  lib,
  ...
}: let
in {
  options = import ./options.nix {inherit pkgs lib;};
}
