{ stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "coding-fonts";
  version = "1";

  src = builtins.fetchGit {
    url = "https://github.com/leonbreedt/secrets.git";
    ref = "main";
    rev = "aa557b87f7b90eb3fd54ba770ec1749abb0c6b5b";
  };

  sourceRoot = ".";
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/opentype ${src}/fonts/*/*.otf
    install -m444 -Dt $out/share/fonts/truetype ${src}/fonts/*/*.ttf

    runHook postInstall
  '';

  meta = {
    description = "Coding/personal fonts";
  };
}
