{ lib, pkgs, hostname, secrets, user, useX11, isPersonal, ... }:

{
  imports = [
    ../common
  ];

  nix = {
    settings.allowed-users = [ "${user}" ];
  };

  time.timeZone = "Pacific/Auckland";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.hostName = hostname;
  networking.useDHCP = false;

  # IPv6, yech.
  networking.enableIPv6 = false;

  # Remember GnuPG passwords.
  programs.gnupg.agent.enable = true;

  # Needed both here and in home-manager.
  programs.fish.enable = true;

  # Local mail (e.g. cron jobs)
  programs.msmtp = {
    enable = true;
    defaults = {
      aliases = "/etc/aliases";
    };
    accounts = {
      default = {
        from = "noreply@sector42.io";
        auth = true;
        tls = true;
        host = "smtp.gmail.com";
        port = "587";
        syslog = true;
        user = secrets.smtp-user;
        password = secrets.smtp-password;
      };
    };
  };
  environment.etc = {
    "aliases" = {
      text = ''
        root: leon@sector42.io
        leon: leon@sector42.io
        unifi: leon@sector42.io
      '';
      mode = "0644";
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # Support Docker
  virtualisation.docker = {
    enable = true;
    listenOptions = [
      "0.0.0.0:2375"
      "/run/docker.sock"
    ];
    logDriver = "json-file";
  };

  environment.systemPackages = with pkgs; [
    inetutils
    moreutils
    tarsnap
    ssl-cert-check
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 2375 ];
  };

  # custom fonts
  fonts = {
    fontDir.enable = useX11;
    packages = with pkgs; lib.optionals useX11 [
      (iosevka.override {
        privateBuildPlan = builtins.readFile ../common/config/iosevka-lb;
        set = "lb";
      })
    ];
  };

  # X11
  services.xserver.enable = useX11;

  # to use bspwm
  #services.displayManager.defaultSession = "none+bspwm";

  # to use gnome
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # to use lightdm when using bspwm
  services.xserver.displayManager.lightdm = {
    enable = false;
    greeters.slick = {
      enable = useX11;
      font.name = "IosevkaLB 12";
      cursorTheme.size = 48;
      extraConfig = ''
        xft-dpi=192
        enable-hidpi=on
      '';
    };
    background = ../common/config/wallpaper/color-wave-1.jpg;
  };

  # to use bspwm
  services.xserver.windowManager.bspwm = {
    enable = false;
  };

  # Video
  hardware.opengl.enable = useX11;
  hardware.opengl.driSupport32Bit = useX11;
  hardware.opengl.driSupport = useX11;

  # Sound
  sound.enable = false; # temporarily disabled
  hardware.pulseaudio.enable = false;

  # Better support for general peripherals
  services.libinput = {
    enable = useX11;
    # macOS for lyfe
    touchpad.naturalScrolling = true;
  };

  # Gaming!
  programs.steam.enable = useX11 && isPersonal;
 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";
}
