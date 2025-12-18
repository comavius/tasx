{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    tasx.url = "file://../../../";
  };

  outputs = inputs:
    inputs.tasx.lib.mkOutputs inputs {
      jsonSrc = ./tasx.json;
    };
}
