# nixOS-specific packages
{ pkgs, useX11, ... }:

with pkgs; [
] ++ lib.optionals useX11 [
    feh
    scrot
    ucs-fonts
]
