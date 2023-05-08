# Main nix-darwin configurations.

{ lib, config, pkgs, nixpkgs, secrets, user, hostname, machineConfig, ... }:

let
  home           = builtins.getEnv "HOME";
in
{
  imports = [
    ../common
    ./home-manager.nix
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nixUnstable;
    settings.trusted-users = [ "@admin" "${user}" ];

    gc = {
      user = "root";
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs; (import ../common/packages.nix { lib = lib; pkgs = pkgs; machineConfig = machineConfig; });

  # Sets all macOS hostname preferences to this value.
  networking.hostName = "${hostname}";

  # Needs to be off.
  programs = { };

  # Allow Fish shell
  environment.shells = [ pkgs.fish ];

  # Enable fonts dir
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (iosevka.override {
        privateBuildPlan = builtins.readFile ../common/config/iosevka-lb;
        set = "lb";
      })
    ];
  };

  # Sector42 CA
  security.pki.certificates = [
    (builtins.readFile ../common/config/sector42-ca.pem)
  ];

  launchd.daemons."nix-store-optimise".serviceConfig = {
    ProgramArguments = [
      "/bin/sh"
      "-c"
      "/bin/wait4path ${config.nix.package}/bin/nix && exec ${config.nix.package}/bin/nix store optimise"
    ];
    StartCalendarInterval = [
      {
        Hour = 2;
        Minute = 30;
      }
    ];
    StandardErrorPath = "/tmp/nix-store.err.log";
    StandardOutPath = "/tmp/nix-store.out.log";
  };

  system = {
    stateVersion = 4;

    # Global configuration of macOS preferences.
    # Reference: https://daiderd.com/nix-darwin/manual/index.htm
    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;
        AppleInterfaceStyle = "Dark";

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;

        # Use F1, F2, etc as function keys.
        "com.apple.keyboard.fnState" = true;

        # Expand save panels by default.
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };

      finder = {
        # List view
        FXPreferredViewStyle = "Nlsv";

        # Search current folder, not Mac.
        FXDefaultSearchScope = "SCcf";
      };

      dock = {
        autohide = false;
        show-recents = false;
        launchanim = true;
        mineffect = "scale";
        orientation = "left";
        tilesize = 48;
      };
    };
  };
}
