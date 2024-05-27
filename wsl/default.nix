# WSL-specific configuration

{ lib, pkgs, user, ... }:

{
  # Enable WSL support.
  wsl = {
    enable = true;
    defaultUser = "${user}";

    # Use native systemd support.
    nativeSystemd = true;

    # Enable native Docker support.
    docker-native.enable = true;

    # Don't include NixOS-WSL flake in tarball.
    tarball.includeConfig = false;
  };
}
