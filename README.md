# Tasx: Tiny Task Runner with Nix-Flakes
Tasx is a task runner and minimal wrapper library around Nix Flakes, providing beginner-friendly but highly programmable interfaces and deterministic task execution.

## Usage
Tasx supports two configuration styles: JSON and Nix expression. With Nix expression style, it offers `tasx.lib.mkApps` and `tasx.lib.flakeModule`, allowing seamless integration with both `flake-utils` and `flake-parts`.

Also, tasx provides a command-line tool to run tasks defined more conveniently.
```bash
tasx <task-name>
# The command above is equivalent to
nix run ".#tasx:<task-name>"
# installing tasx via nix
nix profile install "github:comavius/tasx"
# or running tasx once without installation
nix run "github:comavius/tasx" <task-name>
```

### Configuration file (JSON)
This is an example `tasx.json` configuration file:
```json
{
    "globalEnv": [
        "hello"
    ],
    "enableGitPlugin": true,
    "tasks": {
        "greet1": {
            "cmd": "hello"
        },
        "greet2": "hello",
        "greet3": {
            "cmd": "cowsay Hello, World!",
            "env": [
                "cowsay"
            ]
        },
        "printGitRoot": {
            "cmd": "in-git-root pwd"
        }
    }
}
```

You can import this JSON file with `tasx.lib.mkOutputs` in your flake.
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    tasx.url = "github:comavius/tasx";
    tasx.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    inputs.tasx.lib.mkOutputs inputs {
      jsonSrc = ./tasx.json;
    };
}
```

### Configuration file (Nix)
This is an example `tasx.nix` configuration file:
```nix
# tasx.nix
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
```

### flake-utils example
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    tasx.url = "github:comavius/tasx";
    tasx.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    tasx,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        tasxConf = import ./tasx.nix;
      in {
        apps = tasx.lib.mkApps {
          inherit pkgs tasxConf;
        };
        devShells.default = pkgs.mkShell {
          buildInputs = [tasx.packages."${system}".default];
        };
      }
    );
}

```

### flake-parts example
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    tasx.url = "github:comavius/tasx";
    tasx.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    tasx,
  }:
    flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      imports = [
        tasx.lib.flakeModules.default
      ];
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      perSystem = {pkgs, ...}: {
        tasx = import ./tasx.nix {inherit pkgs;};
        devShells.default = pkgs.mkShell {
          buildInputs = [tasx.packages."${system}".default];
        };
      };
    });
}
```
