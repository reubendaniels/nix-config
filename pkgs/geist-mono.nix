{ lib, stdenvNoCC, fetchurl, unzip }:

stdenvNoCC.mkDerivation rec {
  pname = "geist-mono";
  version = "1";

  src = fetchurl {
    url = "https://github.com/vercel/geist-font/releases/download/1.0.0/Geist.Mono.zip";
    sha256 = "sha256-Cr90HvfYxycP+huWjHY9ZUYXyayYClA6uYwVJpMlo4s=";
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    unzip ${src}
    cd "Geist Mono"

    install -m444 -Dt $out/share/fonts/opentype GeistMono*.otf

    runHook postInstall
  '';

  meta = {
    description = "Vercel developer font.";
    homepage = "https://vercel.com/font/mono";
    license = lib.licenses.ofl;
  };
}
