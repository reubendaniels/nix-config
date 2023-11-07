let 
  chromePkgs = import (fetchTarball https://github.com/nixos/nixpkgs/archive/8f824c9d1315fb0a3a74277b64d24c632f6a92d2.tar.gz) {};
in
self: super: {
  chromedriver-latest = chromePkgs.chromedriver;
}
