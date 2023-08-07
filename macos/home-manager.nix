# macOS specific home-manager configuration

{ config, pkgs, lib, secrets, user, hostname, machineConfig, ... }:

let
  homeDir = builtins.getEnv "HOME";
  xdg_configHome = "${homeDir}/.config";
  common-programs = import ../common/home-manager.nix { config = config; pkgs = pkgs; lib = lib; secrets = secrets; };
  common-files = import ../common/files.nix { secrets = secrets; };
  mas-apps = import ./apps.nix { lib = lib; machineConfig = machineConfig; };
in
{
  imports = [
    <home-manager/nix-darwin>
   ./dock.nix
  ];

  # Declarative Dock configuration
  local.dock = {
    enable = true;
    entries = [
      { path = "/System/Cryptexes/App/System/Applications/Safari.app/"; }
      { path = "${pkgs.wezterm}/Applications/WezTerm.app/"; }
    ] ++ lib.optionals machineConfig.isPersonal [
      { path = "/System/Applications/Messages.app/"; }
      { path = "/System/Applications/Photos.app/"; }
      { path = "/Applications/Mimestream.app/"; }
    ];
  };

  # Only for work.
  services.redis.enable = !machineConfig.isPersonal;

  # Homebrew is only used to install Mac apps we can't get via nixpkgs,
  # it's not even in $PATH so we don't get tempted to use it for anything
  # else.
  homebrew = {
    enable = true;
    brewPrefix = "/opt/homebrew/bin";
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    casks = pkgs.callPackage ./casks.nix { lib = lib; machineConfig = machineConfig; };
    masApps = mas-apps;
  };

  # User base configuration.
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.fish;
  };

  # Home manager configuration.
  home-manager = {
    useGlobalPkgs = true;

    users.${user} = {
      home = {
        stateVersion = "22.05";

        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix { pkgs = pkgs; machineConfig = machineConfig; };
        file = common-files // import ./files.nix { user = user; machineConfig = machineConfig; };

        # Environment
        sessionVariables = {
          TERM = "xterm-256color";
          LANG = "en_US.UTF-8";
          LC_CTYPE = "en_US.UTF-8";
          LC_ALL = "en_US.UTF-8";
          EDITOR = "nvim";
          PAGER = "bat -p";
          MANPAGER = "bat -p";

          # Allow rust-analyzer to find the Rust source
          RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

          # Use our current Java version always
          JAVA_HOME = "${pkgs.jdk17}";

          # Use remote Docker server for Macs.
          DOCKER_HOST = builtins.readFile "${secrets}/docker-server-ip";
        };

        activation = {
          setWallpaper = ''
            osascript -e 'tell application "System Events" to tell every desktop to set picture to "${homeDir}/Pictures/wallpaper.jpg"'
          '';
          setRootCaCertificates = ''
            sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ${xdg_configHome}/ssl/certs/sector42-ca.pem
          '';
        };
      };

      programs = common-programs;
    };
  };
}
