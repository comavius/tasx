{lib, ...}: {
  options = {
    globalPackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };

    enableGitPlugin = lib.mkEnableOption "Enable Git plugin for tasx.";

    tasks = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          (
            lib.types.submodule {
              options = {
                cmd = lib.mkOption {
                  type = lib.types.str;
                };
                packages = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [];
                };
              };
            }
          )
        ]
      );
    };
  };
}
