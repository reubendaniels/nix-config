# nixOS-specific packages
{ pkgs, useX11, useGnome, ... }:

with pkgs; [
] ++ lib.optionals useX11 [
  feh
  scrot
  ucs-fonts
  sf-pro
  google-chrome
  firefox
] ++ lib.optionals useGnome [
  gnome.gnome-tweaks
]
