{pkgs, ...}: {
  enable = true;

  # optional
  globalEnv = [pkgs.hello];

  # optional
  gitPlugin = {
    enable = true;
    # optional: defaults to pkgs.git
    program = pkgs.git;
  };

  tasks = {
    greet1 = {
      cmd = "hello";
    };

    # syntactic sugar for the above
    greet2 = "hello";

    greet3 = {
      cmd = "cowsay Hello, World!";
      # optional
      env = [pkgs.cowsay];
    };

    # in-git-root command provided by the gitPlugin
    printGitRoot = {
      cmd = "in-git-root pwd";
    };
  };
}
