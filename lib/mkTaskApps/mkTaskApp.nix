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
  libPath = lib.makeLibraryPath inputs;
  script = ''
    ${preCmdHook}
    export PATH=${binPath}:$PATH
    export LD_LIBRARY_PATH=${libPath}:$LD_LIBRARY_PATH
    ${task'.cmd}
  '';
  drv = writeShellScriptBin "tasx-task" script;
in {
  type = "app";
  program = "${drv}/bin/tasx-task";
}
