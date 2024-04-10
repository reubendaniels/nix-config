# Common packages installed on all systems

{ pkgs, isPersonal }:

with pkgs; [
  awscli2
  bat
  bun
  cascadia-code
  coding-fonts
  cloudfoundry-cli
  curl
  deno
  difftastic
  du-dust
  eza
  fd
  fish
  flyctl
  fzf
  geist-mono
  gh
  git-lfs
  gnupg
  go
  gopls
  htop
  inetutils
  intel-one-mono
  jdk17
  jetbrains-mono
  jq
  kubectl
  kubelogin-oidc
  maven
  neofetch
  nmap
  nodePackages."@tailwindcss/language-server"
  nodePackages.typescript-language-server
  nodejs-18_x
  openssl
  pkg-config
  protobuf
  pwgen
  ripgrep
  ruby_3_3
  rubyPackages_3_3.solargraph
  rustup
  rust-cbindgen
  shellcheck
  sf-mono
  step-cli
  sqlite
  swift-format
  terraform
  tree
  tmux
  unrar
  unzip
  vault
  wrk
  xsv
  xh
  zig
  zls
  zip
] ++ lib.optionals (!isPersonal) [
  # from overlay
  chromedriver-latest
  vscode
] ++ lib.optionals isPersonal [
  pinentry_mac
]
