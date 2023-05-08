{ lib, pkgs, machineConfig }:

with pkgs;
let common-packages = import ../common/packages.nix { lib = lib; pkgs = pkgs; machineConfig = machineConfig; }; in
common-packages ++ [
    pwgen
]
++
lib.optionals machineConfig.isDesktop [
    feh
    scrot
    ucs-fonts
]
