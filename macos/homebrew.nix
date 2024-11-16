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
    "orbstack"
    "discord"
  ] ++ lib.optionals (!isPersonal) [
    "postman"
  ];

  masApps = {
    "microsoft-outlook" = 985367838;
    "microsoft-word" = 462054704;
    "microsoft-excel" = 462058435;
    "microsoft-powerpoint" = 462062816;
    "slack-for-desktop" = 803453959;
    "whatsapp-messenger" = 310633997;
    "amazon-prime-video" = 545519333;
    "the-unarchiver" = 425424353;
    "parallels-desktop" = 1085114709;
    "apple-developer" = 640199958;
    "pixelmator-pro" = 1289583905;
    "apple-remote-desktop" = 409907375;
    "1password-for-safari" = 1569813296;
    "messenger" = 1480068668;
    "transmit-5" = 1436522307;
  };
}

