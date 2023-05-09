# Packages that we want installed on every machine.

{ lib, pkgs, machineConfig }:

with pkgs; [
  awscli2
  bat
  bun
  cargo
  clippy
  cloudfoundry-cli
  curl
  difftastic
  deno
  du-dust
  exa
  emacs
  fd
  fish
  flyctl
  font-awesome
  fzf
  gh
  git-lfs
  gnupg
  google-cloud-sdk
  google-java-format
  go
  gopls
  htop
  inetutils
  jdk17
  jetbrains-mono
  jq
  kubectl
  maven
  neofetch
  nmap
  nodePackages.pnpm
  nodePackages."@tailwindcss/language-server"
  nodePackages.typescript-language-server
  nodejs-16_x
  pinentry
  ripgrep
  rustc
  rustfmt
  rye
  step-cli
  sqlite
  terraform
  tree
  tmux
  unrar
  unzip
  vault
  wrk
  zig
  zls
  zip
]
++
lib.optionals machineConfig.isDesktop [
  chromedriver
  cascadia-code
  sf-mono
  vscode
]
