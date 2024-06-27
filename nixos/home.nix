# nixOS-specific user configuration
{ isWsl, ... }:

{
  xsession.windowManager.bspwm = {
    enable = !isWsl;
    monitors = {
      "DP-0" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
      "DP-1" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
      "DP-2" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
      "DP-3" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
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

}
