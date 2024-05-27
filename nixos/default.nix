{ lib, pkgs, hostname, secrets, user,  ... }:

let
  keys = [
    # public key
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCz89QU2uyL7hhfgVPP6l9XFBViQBk2zMpD06MZicl/0BJnlJTfqOWEIcU37NbEME0gbJpan7OEdrwr3xDevsx+mCCzARDDotKzE27/mrPkjVosaM0jxqxBOWvGRGr/l2rbmXyKGP4G21QHcwNk5KWKgOCcp4MhxH5Gpb4xA7JITuB5rH+83PF9nmsSELQpo9zKpJYhOO8O1cKUOMkdvB73hpe28vMRfaEouc2ElsiVhT+hEU/Pux3bxCvy+vHAMlA3xBW6BKb442EvCo0+ulhtILvPjjjMCOYE7bTjRbTltkpMD/pTeWB5kbMd/+Grrt393VspYnLCmUCoNAKfSqdsf5WSx+sBF5HRzikboe0oz6ejRnbjcA5vVyTGID/xZwg0xwUqFaBF+PdCDyk2SX29T2WKu6ewDLl25uv085h332xfb40qTlf6OQysQsiC5boImzMdVhbWl9dLNvd0XSR36iF1iieJE+3W+v9grHqD6IUkdt/kDiTqWsfgTSyVutM="
  ];
in
{
  imports = [
    ../common
  ];

  # Use unstable Nix so we can use flakes.
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.allowed-users = [ "${user}" ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
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
    accounts.default = {
      from = "noreply@sector42.io";
      auth = true;
      tls = true;
      host = "smtp.gmail.com";
      port = "587";
      syslog = true;
      user = builtins.readFile "${secrets}/smtp-user";
      password = builtins.readFile "${secrets}/smtp-password";
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

  # It's me
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = keys;
  };

  environment.systemPackages = with pkgs; [
    inetutils
    moreutils
    tarsnap
    ssl-cert-check
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ] ++ lib.optionals machineConfig.enableDocker [ 2375 ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
