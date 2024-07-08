let 
  chromePkgs = import (fetchTarball https://github.com/nixos/nixpkgs/archive/f424ca5c4fa297ba784f41ec8bd3ba63c3e61076.tar.gz) {};
in
self: super: {
  chromedriver-latest = chromePkgs.chromedriver;
}
