{pkgs, ...}: {
  enable = true;
  globalEnv = [pkgs.hello];

  tasks = {
    greet1 = {
      cmd = "hello";
    };

    greet2 = "hello";

    greet3 = {
      cmd = "cowsay Hello, World!";
      env = [pkgs.cowsay];
    };
  };
}
