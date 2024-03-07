# Homebrew configuration for apps not available in nixpkgs.
{lib, isPersonal}:

{
  enable = true;

  onActivation = {
    autoUpdate = true;
    cleanup = "zap";
    upgrade = true;
  };

  casks = [
    "google-chrome"
    "jetbrains-toolbox"
    "postico"
    "postgres-unofficial"
    "zoom"
    "1password"
  ] ++ lib.optionals isPersonal [
    "brave-browser"
    "mimestream"
    "vlc"
    "transmission"    
  ] ++ lib.optionals (!isPersonal) [
    "postman"
  ];

  masApps = {};
}

