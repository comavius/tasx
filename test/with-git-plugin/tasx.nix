{pkgs, ...}: {
  enable = true;
  globalEnv = [pkgs.hello];
  gitPlugin = {
    enable = true;
  };

  tasks = {
    printGitRoot = {
      cmd = "in-git-root pwd";
    };

    printCwd = {
      cmd = "pwd";
    };
  };
}
