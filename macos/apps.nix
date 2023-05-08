# Applications to install from Mac App Store.
# Find their IDs by running (make sure you are looking at the right match in MAS app if unsure):
#   /opt/homebrew/bin/mas search <app name>

{ lib, machineConfig, ... }:

lib.mkIf machineConfig.isPersonal {
  "1blocker" = 1365531024;
  "1password" = 1333542190;
  "1password-for-safari" = 1569813296;
  "tailscale" = 1475387142;
}
