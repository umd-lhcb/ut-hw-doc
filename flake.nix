{
  description = "UMD UT hardward documentation website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.url = "github:DavHau/mach-nix/3.1.1";
  };

  outputs = { self, nixpkgs, flake-utils, mach-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs { inherit system; }).pkgs;
        mach-nix-utils = import mach-nix { inherit pkgs; };
      in
      rec {
        devShell = mach-nix-utils.mkPythonShell {
          requirements = builtins.readFile ./requirements.txt + "setuptools";
          # NOTE: "setuptools" is the most common missing dependency
        };
      });
}
