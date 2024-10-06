# nixOS-specific packages
{ pkgs, useX11, useGnome, ... }:

with pkgs; [
] ++ lib.optionals useX11 [
  feh
  scrot
  ucs-fonts
  sf-pro
  overpass
  google-chrome
  firefox
  zed-editor
] ++ lib.optionals useGnome [
  gnome.gnome-tweaks
  gnome.epiphany
  gnome.yelp
  gnome.cheese
]
