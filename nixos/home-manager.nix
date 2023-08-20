# NixOS specific home-manager configuration

{ 
  config,
  system,
  pkgs,
  lib,

  secrets,
  user,
  hostname,
  machineConfig,

  ...
}:

let
  common-programs = import ../common/home-manager.nix { config = config; pkgs = pkgs; lib = lib; secrets = secrets; };
  common-files = import ../common/files.nix { secrets = secrets; };
in
{
  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";

    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix { lib = lib; pkgs = pkgs; machineConfig = machineConfig; };
    file = common-files // import ./files.nix { user = user; };

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

      JAVA_HOME = "${pkgs.jdk17}";
    };

    stateVersion = "22.11";
  };

  programs = common-programs // {
    rofi = {
      enable = true;
      font = "IosevkaLB 12";
      theme = "paper-float";
    };
  };

  # BSPWM configuration
  xsession.windowManager.bspwm = {
    enable = machineConfig.isDesktop;
    monitors = {
      "Virtual-1" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
      "DP-0" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
      "DP-4" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
    };
    alwaysResetDesktops = true;
    settings = {
      border_width = 4;
      border_radius = 10;
      focused_border_color = "#8fbcbb";
      active_border_color = "#2e3440";
      normal_border_color = "#2e3440";
      top_padding = 60;
      window_gap = 20;
      borderless_monocle = true;
      gapless_monocle = false;
      split_ratio = 0.52;
      focus_follows_pointer = true;
    };
    extraConfig = ''
      feh --bg-scale ~/.wallpaper
    '';
  };

  # keyboard shortcuts
  services.sxhkd = {
    enable = machineConfig.isDesktop;
    keybindings = {
      "super + Return" = "kitty";
      "super + @space" = "rofi -show run";
      "super + shift + q" = "bspc quit";
      # focus node in direction
      "super + {_,shift + }{Left,Down,Up,Right}" = "bspc node -{f,s} {west,south,north,east} --follow";
      # move window between monitors
      "super + alt + {Left,Right}" = "bspc node -m {prev,next} --follow";
      # switch desktops
      "super + 1" = "bspc desktop -f 1";
      "super + 2" = "bspc desktop -f 2";
      "super + 3" = "bspc desktop -f 3";
      "super + 4" = "bspc desktop -f 4";
      "super + 5" = "bspc desktop -f 5";
      "super + 6" = "bspc desktop -f 6";
      "super + 7" = "bspc desktop -f 7";
      "super + 8" = "bspc desktop -f 8";
      "super + 9" = "bspc desktop -f 9";
      # move node to desktop
      "super + shift + 1" = "bspc node -d 1";
      "super + shift + 2" = "bspc node -d 2";
      "super + shift + 3" = "bspc node -d 3";
      "super + shift + 4" = "bspc node -d 4";
      "super + shift + 5" = "bspc node -d 5";
      "super + shift + 6" = "bspc node -d 6";
      "super + shift + 7" = "bspc node -d 7";
      "super + shift + 8" = "bspc node -d 8";
      "super + shift + 9" = "bspc node -d 9";
    };
  };

  # compositor
  services.picom = {
    enable = machineConfig.isDesktop;
    shadow = true;

    settings = {
      "shadow-radius" = 20;
      "corner-radius" = 10;
      "rounded-corners-exclude" = ["! class_g = 'Polybar' && ! class_g = 'Rofi'"];
    };
  };

  # utility toolbars
  services.polybar = {
    enable = machineConfig.isDesktop;
    config = ./config/polybar;
    script = ''
      polybar desktop &
      polybar status &
      polybar title &
    '';
  };
  systemd.user.services.polybar.Install.WantedBy = [ "graphical-session.target" "tray.target" ];

  # global X11 configuration
  xresources.extraConfig = ''
    ${builtins.readFile ./config/Xresources}

    ! monitor names used in configuration
    *monitor1: DP-4
    *monitor2: DP-0
  '';

  # make cursor not tiny on HiDPI screens
  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}
