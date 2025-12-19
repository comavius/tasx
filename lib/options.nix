{
  pkgs,
  lib,
  ...
}: {
  enable = lib.mkEnableOption "Enable tasx task runner.";

  gitPlugin = {
    enable = lib.mkEnableOption "Enable Git plugin for tasx.";
    program = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.git;
      description = "Git program to be used by the Git plugin.";
    };
  };

  tasks = lib.mkOption {
    default = {};
    description = "Task definitions for tasx.";
    type = lib.types.lazyAttrsOf (
      lib.types.oneOf [
        lib.types.str
        (
          lib.types.submodule {
            options = {
              cmd = lib.mkOption {
                type = lib.types.str;
                description = "Command to be executed for this task.";
              };
              packages = lib.mkOption {
                type = lib.types.nullOr (lib.types.listOf lib.types.package);
                default = [];
                description = "Environment packages specific to this task.";
              };
            };
          }
        )
      ]
    );
  };

  globalPackages = lib.mkOption {
    type = lib.types.nullOr (lib.types.listOf lib.types.package);
    default = [];
    description = "Global environment packages applied to all tasks.";
  };
}
