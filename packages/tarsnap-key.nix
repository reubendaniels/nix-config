{ pkgs, secrets, hostname }:

pkgs.stdenv.mkDerivation rec {
  name = "tarsnap-key";

  src = [
    "${secrets}/tarsnap-${hostname}.key"
  ];

  unpackPhase = "true";

  installPhase = ''
    mkdir $out
    cp $src $out/tarsnap.key
  '';
}
