{ machineConfig, ... }:

let
  home           = builtins.getEnv "HOME";
  xdg_configHome = "${home}/.config";
in
{
  "${home}/Pictures/wallpaper.jpg".source = if machineConfig.isPersonal 
    then ../common/config/color-wave-2.jpg
    else ../common/config/color-wave-5.jpg;

  "${xdg_configHome}/ssl/certs/sector42-ca.pem".source = ../common/config/sector42-ca.pem;
}
