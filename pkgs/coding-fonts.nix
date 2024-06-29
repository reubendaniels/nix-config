{ stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "coding-fonts";
  version = "1";

  src = builtins.fetchGit {
    url = "https://github.com/leonbreedt/secrets.git";
    ref = "main";
    rev = "1796240b3615b90e1bd2b19f5204c7a6b519a8faa";
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
