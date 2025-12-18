{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    tasx.url = "github:comavius/tasx";
  };

  outputs = inputs:
    inputs.tasx.lib.mkOutputs inputs {
      jsonSrc = ./tasx.json;
    };
}
