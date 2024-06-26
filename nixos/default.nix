{ lib, pkgs, hostname, secrets, user,  ... }:

{
  imports = [
    ../common
  ];

  nix = {
    settings.allowed-users = [ "${user}" ];
  };

  # Use the systemd-boot EFI boot loader.

  # TODO: make WSL parameterizable, disable this on WSL.
  # boot.loader.systemd-boot.enable = !wsl.enable;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";
}
