# Home manager configuration that is OS independent.

{ config, pkgs, lib, secrets, ... }:

let
  workProjectDir = (builtins.readFile "${secrets}/work-project-dir");
in
{
  # Shell
  fish = {
    enable = true;
    shellInit = ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
      end
      if test -d /run/current-system/sw/bin
        fish_add_path /run/current-system/sw/bin
      end
      if test -d /run/wrappers/bin
        fish_add_path /run/wrappers/bin
      end
      if test -d $HOME/.rye/shims
        fish_add_path $HOME/.cargo/bin
      end
      if test -d $HOME/.cargo/bin
        fish_add_path $HOME/.cargo/bin
      end
      if test -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
        fish_add_path "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
      end
      if test -d "/Applications/Postgres.app/Contents/Versions/latest/bin"
        fish_add_path "/Applications/Postgres.app/Contents/Versions/latest/bin"
      end

      set -gx CDPATH . $HOME/${workProjectDir} $HOME/Source $HOME/source

      alias kc kubectl
      alias cat "bat -p"
      alias less "bat -p"
    '';
    plugins = [
      {
        name = "theme-bobthefish";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-bobthefish";
          rev = "2dcfcab653ae69ae95ab57217fe64c97ae05d8de";
          sha256 = "sha256-jBbm0wTNZ7jSoGFxRkTz96QHpc5ViAw9RGsRBkCQEIU=";
        };
      }
    ];
  };

  # Terminal
  kitty = {
    enable = true;
    extraConfig = builtins.readFile ./config/kitty;
  };

  # Git
  git = {
    enable = true;
    lfs.enable = true;
    aliases = {
      co = "checkout";
      ca = "commit --all";
      fa = "fetch --all";
      fap = "!git fetch --all && git pull --autostash";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      st = "status";
      root = "rev-parse --show-toplevel";
    };
    includes = [
      {
        path = "~/.config/git/personal";
        condition = "gitdir:~/";
      }
      {
        path = "~/.config/git/personal";
        condition = "gitdir:~/Source/";
      }
      {
        path = "~/.config/git/work";
        condition = "gitdir:~/${workProjectDir}/";
      }
      {
        path = "~/.config/git/work";
        condition = "gitdir:/var/";
      }
      {
        path = "~/.config/git/personal";
        condition = "gitdir:/etc/nixos/";
      }
    ];
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      color.diff = "auto";
      color.status = "auto";
      color.interactive = "auto";
      color.pager = true;
      core.askPass = "";
      credential.helper = "store";
      credentialstore.locktimeoutms = 0;
      github.user = "leonbreedt";
      push.default = "tracking";
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };

  neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs; [
      # Theme/appearance
      vimPlugins.lightline-vim
      customVimPlugins.catppuccin-nvim

      # LSP
      vimPlugins.nvim-lspconfig

      # languages
      vimPlugins.rust-vim
      vimPlugins.zig-vim
      vimPlugins.vim-nix
      vimPlugins.vim-fish

      # completion
      vimPlugins.cmp-nvim-lsp
      vimPlugins.cmp-buffer
      vimPlugins.cmp-path
      vimPlugins.cmp-cmdline
      vimPlugins.nvim-cmp
      vimPlugins.cmp-vsnip
      vimPlugins.vim-vsnip

      # popups
      vimPlugins.popfix
      customVimPlugins.popui-nvim

      # tree sitter
      (vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
        tree-sitter-c
        tree-sitter-cpp
        tree-sitter-go
        tree-sitter-nix
        tree-sitter-rust
      ]))
    ];
    
    extraConfig = builtins.readFile ./config/nvim;

    # Language servers
    extraPackages = with pkgs; [
      rust-analyzer
      gopls
    ];
  };

  gpg.enable = true;
  direnv.enable = true;

  wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./config/wezterm.lua;
  };
}
