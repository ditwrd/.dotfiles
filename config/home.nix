{ config, sops-nix, ... }:

{
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


  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/nvim";
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/hypr";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/waybar";
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/kitty";
    ".config/herdr/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/herdr/config.toml";
    ".config/herdr/plugins/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/herdr/plugins/config";
    ".omp/agent/config.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/omp/config.yml";
    ".omp/agent/mcp.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/omp/mcp.json";
    ".omp/agent/commands".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/omp/commands";
    ".omp/agent/extensions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/omp/extensions";
    ".zsh/zsh-autosuggestions".source = .././shell/zsh-autosuggestions;
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/shell/starship.toml";
    ".config/zellij/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/shell/zellij.kdl";
    ".config/mise/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/shell/mise-config.toml";
    ".ssh/snowflake_tf.p8".source = config.lib.file.mkOutOfStoreSymlink "${config.sops.secrets."key/cube/snow".path}";
    ".ssh/github_cube".source = config.lib.file.mkOutOfStoreSymlink "${config.sops.secrets."ssh/work/cube/gh".path}";
    ".ssh/github".source = config.lib.file.mkOutOfStoreSymlink "${config.sops.secrets."ssh/personal/gh".path}";
      
  };

  home.sessionVariables = {
    # EDITOR = "nvim";
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
    AWS_PROFILE = "$(cat ${config.home.homeDirectory}/.awsd)";
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
