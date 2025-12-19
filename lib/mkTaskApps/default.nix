{
  callPackage,
  lib,
  ...
}: let
  mkGitPluginHook = callPackage (import ./mkGitPluginHook.nix) {};
  mkTaskApp = callPackage (import ./mkTaskApp.nix) {};
in
  {
    globalPackages,
    tasks,
    gitPlugin,
    ...
  }: let
    gitPluginHook = callPackage mkGitPluginHook {inherit gitPlugin;};
    preCmdHook = gitPluginHook;
    taskApps =
      lib.mapAttrs' (name: task: {
        name = "tasx:${name}";
        value = mkTaskApp {
          inherit globalPackages preCmdHook task;
        };
      })
      tasks;
  in
    taskApps
