{lib, ...}: {
  options = {
    globalEnv = lib.mkOption {
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
                env = lib.mkOption {
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
