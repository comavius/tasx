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
