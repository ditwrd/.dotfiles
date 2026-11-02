{
  config,
  pkgs,
  lib,
  sops-nix,
  username,
  homeDirectory,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/projects/personal/.dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in {
  home.username = username;
  home.homeDirectory = homeDirectory;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.file = {
    ".config/nvim".source = link "nvim";
    ".config/kitty".source = link "kitty";
    ".config/herdr/config.toml".source = link "herdr/config.toml";
    ".config/herdr/plugins/config".source = link "herdr/plugins/config";
    ".config/tern/settings.json".source = link "tern/settings.json";
    ".omp/agent/config.yml".source = link "omp/config.yml";
    ".omp/agent/mcp.json".source = link "omp/mcp.json";
    ".omp/agent/commands".source = link "omp/commands";
    ".omp/agent/extensions".source = link "omp/extensions";
    ".zsh/zsh-autosuggestions".source = .././shell/zsh-autosuggestions;
    ".config/starship.toml".source = link "shell/starship.toml";
    ".config/zellij/config.kdl".source = link "shell/zellij.kdl";
    ".config/mise/config.toml".source = link "shell/mise-config.toml";
    ".ssh/snowflake_tf.p8".source = config.lib.file.mkOutOfStoreSymlink "${config.sops.secrets."key/cube/snow".path}";
    ".ssh/github_cube".source = config.lib.file.mkOutOfStoreSymlink "${config.sops.secrets."ssh/work/cube/gh".path}";
    ".ssh/github".source = config.lib.file.mkOutOfStoreSymlink "${config.sops.secrets."ssh/personal/gh".path}";
  };

  home.sessionVariables =
    {
      # EDITOR = "nvim";
      AWS_PROFILE = "$(cat ${config.home.homeDirectory}/.awsd)";
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
    };

  imports = [
    sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ./.secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };
  };
}
