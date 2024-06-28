# nixOS-specific packages
{ pkgs, useX11, ... }:

with pkgs; [
] ++ lib.optionals useX11 [
    gnome.gnome-tweaks
    feh
    scrot
    ucs-fonts
    sf-pro
    google-chrome
    firefox
]
