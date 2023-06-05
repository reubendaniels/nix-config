# Packages that we want installed on every machine.

{ lib, pkgs, machineConfig }:

with pkgs; [
  awscli2
  bat
  bun
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
  kubelogin-oidc
  maven
  neofetch
  nmap
  nodePackages.pnpm
  nodePackages."@tailwindcss/language-server"
  nodePackages.typescript-language-server
  nodejs-18_x
  openssl
  pinentry
  pkg-config
  ripgrep
  rye
  rustup
  cascadia-code
  sf-mono
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
lib.optionals (machineConfig.isDesktop || !machineConfig.isPersonal) [
  chromedriver
  vscode
]
