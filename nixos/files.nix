{ user, ... }:

let
  home           = builtins.getEnv "HOME";
  xdg_configHome = "${home}/.config";
in
{
  "${home}/.inputrc".source = ./config/inputrc;
  "${xdg_configHome}/kitty/os.conf".source = ../common/config/kitty-linux;
  "${home}/.wallpaper".source = ../common/config/color-wave-1.jpg;
}
