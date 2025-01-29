{ config, pkgs, ... }:
{
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    compression = true;
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    initExtraFirst = builtins.readFile ../zsh/zsh_first.sh;
    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      
      eval `ssh-agent -s` &>/dev/null
      ssh-add ${config.sops.secrets."ssh/personal/gh".path} &>/dev/null
      ssh-add ${config.sops.secrets."ssh/work/cube/gh".path} &>/dev/null

      export PATH="$PATH:${config.home.homeDirectory}/go/bin"
      export PATH="$PATH:${config.home.homeDirectory}/.nix-profile/bin"
      export VOLTA_HOME="$HOME/.volta"
      export PATH="$PATH:$VOLTA_HOME/bin"

    '';
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    custom = "${config.home.homeDirectory}/.zsh_custom";
    plugins = [
      "ansible"
      "aws"
      "colorize"
      "docker"
      "docker-compose"
      "eza"
      "fzf"
      "git"
      "gitignore"
      "golang"
      "helm"
      "kubectl"
      "ssh"
      "sudo"
      "systemd"
      "terraform"
      "tmux"
      "volta"
      "z"
      "zsh-interactive-cd"

      # ── Custom ────────────────────────────────────────────────────────────
      "zshfl"
      "zsh-autosuggestions"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

}
