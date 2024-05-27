# macOS-specific packages
{ pkgs, isPersonal, ... }:

with pkgs; [
] ++ lib.optionals isPersonal [
  pinentry_mac
]
