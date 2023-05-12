# Casks to install via Homebrew, for Mac apps that are not
# available via nixpkgs.

{ lib, machineConfig, ... }:

[
  "brave-browser"
  "google-chrome"
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
++
lib.optionals (!machineConfig.isPersonal) [
  "postman"
]
