{
  # flake-parts compatible module.
  flakeModules.default = import ./flakeModule.nix;

  # flake-utils compatible apps. mkApps itself is callable in callPackage pattern
  # with additional argument `tasxList`.
  mkApps = import ./mkApps.nix;

  # return value of bare flake.nix outputs.
  # mkOutputs :: {
  #   nixpkgs
  #   tasxList
  # } -> {
  #   apps :: attrset<system, app>
  # }
  mkOutputs = import ./mkOutputs.nix;
}
