# macOS specific packages

{ lib, pkgs, machineConfig }:

with pkgs;
let common-packages = import ../common/packages.nix { lib = lib; pkgs = pkgs; machineConfig = machineConfig; }; in
common-packages ++ [
  # stable.jdk17
  dockutil
  # docker CLI
  docker
]
