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
] ++ lib.optionals useGnome [
  gnome.gnome-tweaks
  gedit
  gnome.epiphany
  gnome.yelp
  gnome.cheese
]
