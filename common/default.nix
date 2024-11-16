# Common configuration across systems

{ pkgs, hostname, ... }:

{
  nix = {
    # Don't require --extra-experimental-features every time we
    # want to use 'nix flake'
    extraOptions = "experimental-features = nix-command flakes";

    settings = {
      trusted-substituters = [ "https://ghostty.cachix.org" ];
      trusted-users = [ "root" "reuben" ];
    };
  };

  # Ensure hostname is set system-wide.
  networking.hostName = "${hostname}";

  environment = {
    # Make Fish shell available in /etc/shells
    shells = [ pkgs.fish ];
  };

  # Always allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Set up common programs globally
  programs = import ./programs.nix;
}
