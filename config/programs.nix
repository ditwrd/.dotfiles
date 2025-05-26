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

      export PATH="$PATH:$HOME/.local/bin"
      
      # Ruby
      export GEM_HOME="$(gem env user_gemhome)"
      export PATH="$PATH:$GEM_HOME/bin"
      
      # Go
      export PATH="$PATH:${config.home.homeDirectory}/go/bin"
      
      # Nix
      export PATH="$PATH:${config.home.homeDirectory}/.nix-profile/bin"
      
      # Node
      export VOLTA_HOME="$HOME/.volta"
      export PATH="$PATH:$VOLTA_HOME/bin"
      export PNPM_HOME="${config.home.homeDirectory}/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      # env var
      export ANTHROPIC_API_KEY="$(cat ${config.sops.secrets."env/avante".path})"
      
      kp() {
        local PID=$(lsof -t -i tcp:$1) || return $?
        [ -z "$PID" ] && echo "No process is using this port: $1" && return 0
        local exit_code_kill; kill -9 "$PID" || exit_code_kill="$?"

        if [[ -z $exit_code_kill ]]; then
          echo "Killed process: $PID"
        else
          echo "Failed to kill process: $PID"
        fi
      }
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
