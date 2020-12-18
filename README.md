# ut-hw-doc [![Build status](https://travis-ci.com/umd-lhcb/ut-hw-doc.svg?build)](https://travis-ci.com/umd-lhcb/ut-hw-doc)
Documentation for hardware designed by UMD LHCb group. The website is available
at https://umd-lhcb.github.io/ut-hw-doc


## Test the site locally

### Regular workflow
Install the required Python pacakges via:
```
pip install -r ./requirements.txt
```

Then build the site with the following command:
```
mkdocs serve
```

The website will be avaliable at http://127.0.0.1:8000

### `nix`-based workflow
If you have `nix` with flake support installed, spawn a development shell with:
```
nix develop
```

Then build the site with the same command listed in the previous section.
