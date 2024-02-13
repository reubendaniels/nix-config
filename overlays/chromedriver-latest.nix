let 
  chromePkgs = import (fetchTarball https://github.com/nixos/nixpkgs/archive/897df4cc4d21cefc2b3b298fa75b5a1ab500ebd5.tar.gz) {};
in
self: super: {
  chromedriver-latest = chromePkgs.chromedriver;
}
