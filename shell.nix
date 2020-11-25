let
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix/";
    ref = "refs/tags/3.0.2";
  }) {};
in

mach-nix.mkPythonShell {
  requirements = builtins.readFile ./requirements.txt + "setuptools";
  # NOTE: "setuptools" is the most common missing dependency
}
