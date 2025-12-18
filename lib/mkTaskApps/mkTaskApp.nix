{
  lib,
  writeShellScriptBin,
  ...
}: {
  globalEnv,
  preCmdHook,
  task,
}: let
  task' =
    if lib.isString task
    then {
      cmd = task;
      env = [];
    }
    else task;
  inputs = globalEnv ++ task'.env;
  binPath = lib.makeBinPath inputs;
  script = ''
    ${preCmdHook}
    export PATH=${binPath}:$PATH
    ${task'.cmd}
  '';
  drv = writeShellScriptBin "tasx-task" script;
in {
  type = "app";
  program = "${drv}/bin/tasx-task";
}
