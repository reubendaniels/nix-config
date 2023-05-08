# Casks to install via Homebrew, for Mac apps that are not
# available via nixpkgs.

{ lib, machineConfig, ... }:

[
  "brave-browser"
  "jetbrains-toolbox"
  "postico"
  "postgres-unofficial"
  "zoom"
]
++ 
lib.optionals machineConfig.isPersonal [
  "mimestream"
  "vlc"
  "transmission"
]
