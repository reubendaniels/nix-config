let 
  chromePkgs = import (fetchTarball https://github.com/nixos/nixpkgs/archive/f3ee2a75d473ff9577e9e1b79456f12c08d14858.tar.gz) {};
in
self: super: {
  chromedriver-latest = chromePkgs.chromedriver;
}
