let
  pkgs = import <nixpkgs> {};
  python = pkgs.python3;
  pythonPackages = python.pkgs;
in

pkgs.mkShell {
  name = "ut-hw-doc";
  buildInputs = with pythonPackages; [
    # Python requirements (enough to get a virtualenv going).
    virtualenvwrapper
  ];

  shellHook = ''
    # Allow the use of wheels.
    SOURCE_DATE_EPOCH=$(date +%s)

    if test -d $HOME/build/python-venv; then
      VENV=$HOME/build/python-venv/ut-hw-doc
    else
      VENV=./.virtualenv
    fi

    if test ! -d $VENV; then
      virtualenv $VENV
    fi
    source $VENV/bin/activate
  '';
}
