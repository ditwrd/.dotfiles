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
      # export PATH="$HOME/.asdf/shims:$HOME/.asdf/installs:$PATH"
      
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
      # export ANTHROPIC_API_KEY="$(cat ${config.sops.secrets."env/avante".path})"
      # "http://127.0.0.1:3456"
      export ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic
      export ANTHROPIC_AUTH_TOKEN="$(cat ${config.sops.secrets."env/zai".path})"
      export API_TIMEOUT_MS=600000
      export OPENROUTER_API_KEY="$(cat ${config.sops.secrets."env/openrouter".path})"
      export HSA_OVERRIDE_GFX_VERSION="9.0.0"
      unset DOCKER_HOST
      export TG_PROVIDER_CACHE=1
      
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
      # Initialize zoxide with 'cd' command (disable doctor warnings)
      export _ZO_DOCTOR=0
      eval "$(zoxide init --cmd cd zsh | sed -E 's/(^|[^_])__([a-zA-Z_])/\1\2/g')"
    '';
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    custom = "${config.home.homeDirectory}/.zsh_custom";
    plugins = [
      "ansible"
      "aws"
      # "asdf"
      "mise"
      "colorize"
      "docker"
      "docker-compose"
      "eza"
      "git"
      "gitignore"
      "golang"
      "helm"
      "kubectl"
      "ssh"
      "sudo"
      "systemd"
      "terraform"
      # "zoxide"
      "zsh-interactive-cd"

      # ── Custom ────────────────────────────────────────────────────────────
      "zshfl"
      "zsh-autosuggestions"
      "atuin"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

}
