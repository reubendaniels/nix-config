{ user, ... }:

let
  home           = builtins.getEnv "HOME";
  xdg_configHome = "${home}/.config";
in
{
  "${home}/.inputrc".source = ./config/inputrc;
  "${home}/.wallpaper".source = ../common/config/color-wave-1.jpg;
}
