{
  description = "UMD UT hardward documentation website";

  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix = {
      url = "github:DavHau/mach-nix";
      inputs = { inherit nixpkgs flake-utils; };
    };
  };

  outputs = { self, nixpkgs, flake-utils, mach-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        mkPythonShell = mach-nix.lib.${system}.mkPythonShell;
      in
      {
        devShell = mkPythonShell {
          requirements = builtins.readFile ./requirements.txt + "setuptools";
          # NOTE: "setuptools" is the most common missing dependency
        };
      });
}
