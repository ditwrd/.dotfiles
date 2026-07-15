{ config, pkgs, ... }:
{
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    includes = [
      {
        condition = "gitdir:~/projects/personal/";
        contents = {
          user.email = "aditya.wardianto11@gmail.com";
        };
      }
      {
        condition = "gitdir:~/projects/cube/";
        contents = {
          user.email = "aditya@cube.asia";
        };
      }
    ];
    settings = [
      {
        user = {
          name = "Aditya W";
        };
      }
      {
        pull.rebase = true;
      }
      {
        credential."https://github.com".helper = "!/usr/bin/gh auth git-credential";
      }
      {
        credential."https://gist.github.com".helper = "!/usr/bin/gh auth git-credential";
      }
    ];
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        Compression = true;
        AddKeysToAgent = "yes";
        ForwardAgent = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts= false;
        UserKnownHostsFile="~/.ssh/known_hosts";
        ControlMaster = "auto";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist= "10m";
      };
    };
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    initContent = ''
      if [ -z "$SSH_AUTH_SOCK" ]; then
       eval `ssh-agent -s` &>/dev/null
       ssh-add ~/.config/sops-nix/secrets/ssh/personal/gh &>/dev/null
       ssh-add ~/.config/sops-nix/secrets/ssh/work/cube/gh &>/dev/null
      fi

      export PATH="$PATH:$HOME/.local/bin"
      eval "$(mise activate zsh)"
      
      # Ruby
      export GEM_HOME="$(gem env user_gemhome)"
      export PATH="$PATH:$GEM_HOME/bin"
      
      # Go
      export PATH="$PATH:${config.home.homeDirectory}/go/bin"
      
      # Nix
      export PATH="$PATH:${config.home.homeDirectory}/.nix-profile/bin"
      
      # Node
      export PNPM_HOME="${config.home.homeDirectory}/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      # env var
      # export ANTHROPIC_API_KEY="$(cat ${config.sops.secrets."env/avante".path})"
      # "http://127.0.0.1:3456"
      # export ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic
      # export ANTHROPIC_AUTH_TOKEN="$(cat ${config.sops.secrets."env/zai".path})"
      export API_TIMEOUT_MS=600000
      export OPENROUTER_API_KEY="$(cat ${config.sops.secrets."env/openrouter-cube".path})"
      export HSA_OVERRIDE_GFX_VERSION="9.0.0"
      unset DOCKER_HOST
      export TG_PROVIDER_CACHE=1
      export CONTEXT7_API_KEY=$(cat ${config.sops.secrets."env/context7".path})
      export VANTAGE_API_KEY=$(cat ${config.sops.secrets."env/vantage".path})
      export INSTANCE_VANTAGE_API_KEY=$(cat ${config.sops.secrets."env/instance-vantage".path})
      
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
      
      export EDITOR="$(which nvim)"
       
      export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=true
      
      eval "$(zoxide init --cmd cd zsh | sed -E 's/(^|[^_])__([a-zA-Z_])/\1\2/g')"
      eval "$(starship init zsh)"
      eval "$(atuin init zsh)"
      # export ZELLIJ_AUTO_ATTACH=true
      # eval "$(zellij setup --generate-auto-start zsh)"
      source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
      function gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;}

      eval "$(wt config shell init zsh)"
      
    '';
  };

  # programs.zsh.oh-my-zsh = {
  #   enable = false;
  #   custom = "${config.home.homeDirectory}/.zsh_custom";
  #   plugins = [
  #     "ansible"
  #     "aws"
  #     # "asdf"
  #     "mise"
  #     "colorize"
  #     "docker"
  #     "docker-compose"
  #     "eza"
  #     "git"
  #     "gitignore"
  #     "golang"
  #     "helm"
  #     "kubectl"
  #     "ssh"
  #     "sudo"
  #     "systemd"
  #     "terraform"
  #     # "zoxide"
  #     "zsh-interactive-cd"
  #
  #     # ── Custom ────────────────────────────────────────────────────────────
  #     "zshfl"
  #     "zsh-autosuggestions"
  #     "atuin"
  #   ];
  # };

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
