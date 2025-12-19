{
  lib,
  writeShellScriptBin,
  ...
}: {
  globalPackages,
  preCmdHook,
  task,
}: let
  task' =
    if lib.isString task
    then {
      cmd = task;
      packages = [];
    }
    else task;
  inputs = globalPackages ++ task'.packages;
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
