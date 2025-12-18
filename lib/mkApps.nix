{
  pkgs,
  tasxConf,
  specialArgs ? {},
  ...
}: let
  mkTaskApps = pkgs.callPackage (import ./mkTaskApps) {};
  myModule = import ./myModule.nix;
  evaluated = pkgs.lib.evalModules {
    modules = [myModule tasxConf];
    specialArgs = {inherit pkgs;} // specialArgs;
  };
  cfg = evaluated.config;
  apps =
    if (pkgs.lib.hasAttr "enable" cfg && cfg.enable)
    then (mkTaskApps cfg)
    else
      (
        builtins.warn ''
          tasx:
            `enable` is not set or is set to false, no apps will be created.
            To enable tasx, set `enable = true;` in your configuration.
        '' {}
      );
in
  apps
