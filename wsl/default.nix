{
  pkgs,
  user,
  ...
}: {
  wsl = {
    enable = true;
    defaultUser = "${user}";
    startMenuLaunchers = true;

    # Installer does not support native systemd yet, set to false when
    # building tarball.
    nativeSystemd = false;

    # Enable native Docker support
    docker-native.enable = true;

    # Don't include NixOS-WSL flake in tarball.
    tarball.includeConfig = false;
  };
}
