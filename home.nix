{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dit";
  home.homeDirectory = "/home/dit";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    #          ╭──────────────────────────────────────────────────────────╮
    #          │                    Nvim Dependencies                     │
    #          ╰──────────────────────────────────────────────────────────╯

    # ── Misc ──────────────────────────────────────────────────────────────
    pkgs.ripgrep
    pkgs.lazygit

    # ── LSP ───────────────────────────────────────────────────────────────
    pkgs.nixd
    pkgs.alejandra
    pkgs.deadnix
    pkgs.statix


    #          ╭──────────────────────────────────────────────────────────╮
    #          │                       DevOps Tools                       │
    #          ╰──────────────────────────────────────────────────────────╯

    # ── Cloud CLI ─────────────────────────────────────────────────────────
    pkgs.awscli2
    pkgs.google-cloud-sdk

    # ── IaC ───────────────────────────────────────────────────────────────
    pkgs.ansible
    pkgs.terraform
    pkgs.terraform-docs
    pkgs.terragrunt

    # ── Container ─────────────────────────────────────────────────────────
    pkgs.lazydocker
    pkgs.docker
    pkgs.rootlesskit

    # ── k8s ───────────────────────────────────────────────────────────────
    pkgs.k9s
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.arkade

    # ── Software Tools ────────────────────────────────────────────────────
    pkgs.git
    pkgs.volta
    pkgs.go
    pkgs.uv
    pkgs.rustup

    pkgs.jq
    pkgs.yq

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # AstroNvim
    ".config/nvim".source = ./nvim;
    ".tmux.conf".source = ./tmux/.tmux/.tmux.conf;
    ".tmux.local.conf".source = ./tmux/.tmux.conf.local;
    # Tmux
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dit/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Aditya W";
    userEmail = "hi@ditwrd.dev";
    extraConfig = {
      pull = {
        rebase = true;
      };
    };
  };
}
