{nixpkgs, ...}: {jsonSrc}: let
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
  jsonContent = builtins.fromJSON (builtins.readFile jsonSrc);
  jsonConfModule = _v: jsonContent;
  JsonModule = import ./JsonModule.nix;
  myModule = import ./myModule.nix;
in {
  apps = forAllPkgs (pkgs: let
    mkTaskApps = pkgs.callPackage (import ./mkTaskApps) {};
    jsonModuleEvaluated = pkgs.lib.evalModules {
      modules = [JsonModule jsonConfModule];
    };
    cfg = jsonModuleEvaluated.config;
    tasxConfModule = {...}: {
      enable = true;
      globalEnv = builtins.map (pname: pkgs.${pname}) cfg.globalEnv;
      gitPlugin = {
        enable = cfg.enableGitPlugin;
      };
      tasks =
        pkgs.lib.mapAttrs (
          name: task:
            if pkgs.lib.isString task
            then {
              cmd = task;
              env = [];
            }
            else if pkgs.lib.hasAttr "env" task
            then {
              cmd = task.cmd;
              env = builtins.map (pname: pkgs.${pname}) task.env;
            }
            else {
              cmd = task.cmd;
              env = [];
            }
        )
        cfg.tasks;
    };
    myModuleEvaluated = pkgs.lib.evalModules {
      modules = [myModule tasxConfModule];
      specialArgs = {inherit pkgs;};
    };
    apps = mkTaskApps myModuleEvaluated.config;
  in
    apps);
}
