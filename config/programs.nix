{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.home-manager.enable = true;

  # lazygit reads ~/Library/Application Support unless XDG_CONFIG_HOME is set;
  # the rest of the CLI tools follow the same convention.
  xdg.enable = true;

  xdg.configFile."lazygit/config.yml" = {
    text = ''
      git:
        diffRenderers:
          - command: delta --paging=never
    '';
  };

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
        core.pager = "delta";
      }
      {
        interactive.diffFilter = "delta --color-only";
      }
      {
        delta.navigate = true;
        delta.dark = true;
      }
      {
        merge.conflictStyle = "zdiff3";
      }
      {
        pull.rebase = true;
      }
      {
        credential."https://github.com".helper = "!${lib.getExe pkgs.gh} auth git-credential";
      }
      {
        credential."https://gist.github.com".helper = "!${lib.getExe pkgs.gh} auth git-credential";
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
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "auto";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "10m";
      };
    };
  };

  programs.zsh = {
    enable = true;
    # xdg.enable triggers a future-default warning; pin the legacy layout so
    # ~/.zshrc keeps being written on both platforms.
    dotDir = config.home.homeDirectory;
    autocd = true;
    enableCompletion = true;
    # /usr/share/zsh/site-functions (310 completion files shipped by pacman
    # packages: _docker, _yay, _pacman, …) is outside NIX_PROFILES and was
    # never in fpath.
    initExtraBeforeCompInit = ''
      [[ -d /usr/share/zsh/site-functions ]] && fpath+=(/usr/share/zsh/site-functions)
    '';
    # compinit's audit + fpath scan costs ~58 ms per shell vs ~16 ms for -C.
    # Trust the dump unless the nix profile changed since it was written, so
    # new tools' completions still appear after a home-manager switch.
    completionInit = ''
      autoload -U compinit
      if [[ ~/.zcompdump -nt ~/.local/state/nix/profiles/home-manager ]]; then
        compinit -C
      else
        compinit
      fi
    '';
    initContent = ''
      if [ -z "$SSH_AUTH_SOCK" ]; then
       eval `ssh-agent -s` &>/dev/null
       ssh-add ~/.config/sops-nix/secrets/ssh/personal/gh &>/dev/null
       ssh-add ~/.config/sops-nix/secrets/ssh/work/cube/gh &>/dev/null
      fi

      export PATH="$PATH:$HOME/.local/bin"
      eval "$(mise activate zsh)"

      # Ruby — `gem env user_gemhome` boots a whole ruby interpreter (~180 ms)
      # on every shell, so cache its answer and re-ask only when ruby changes.
      if command -v gem >/dev/null 2>&1; then
        _gem_home_cache="$HOME/.cache/gem_home"
        if [[ ! -s $_gem_home_cache ]] || [[ $_gem_home_cache -ot "$(command -v ruby)" ]]; then
          mkdir -p "$HOME/.cache"
          gem env user_gemhome >| "$_gem_home_cache" 2>/dev/null
        fi
        if [[ -s $_gem_home_cache ]]; then
          export GEM_HOME="$(<"$_gem_home_cache")"
          export PATH="$PATH:$GEM_HOME/bin"
        fi
        unset _gem_home_cache
      fi

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
      ${lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''export HSA_OVERRIDE_GFX_VERSION="9.0.0"''}
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
      [ -f "$HOME/.atuin/bin/env" ] && source "$HOME/.atuin/bin/env"
      eval "$(atuin init zsh)"
      # awsd init costs ~57 ms; cache the generated shell code, refreshing when
      # the binary itself changes.
      if command -v awsd >/dev/null 2>&1; then
        _awsd_init_cache="$HOME/.cache/awsd_init.zsh"
        if [[ ! -s $_awsd_init_cache ]] || [[ $_awsd_init_cache -ot "$(command -v awsd)" ]]; then
          mkdir -p "$HOME/.cache"
          awsd init zsh >| "$_awsd_init_cache" 2>/dev/null
        fi
        [[ -s $_awsd_init_cache ]] && source "$_awsd_init_cache"
        unset _awsd_init_cache
      fi
      # export ZELLIJ_AUTO_ATTACH=true
      # eval "$(zellij setup --generate-auto-start zsh)"
      source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
      function gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;}

      eval "$(wt config shell init zsh)"

    '';
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
