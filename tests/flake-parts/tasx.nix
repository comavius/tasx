{pkgs, ...}: {
  enable = true;
  globalPackages = [pkgs.hello];

  tasks = {
    greet1 = {
      cmd = "hello";
    };

    greet2 = "hello";

    greet3 = {
      cmd = "cowsay Hello, World!";
      packages = [pkgs.cowsay];
    };
  };
}
