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
    ".tmux.conf".source = .././tmux/.tmux/.tmux.conf;
    ".tmux.conf.local".source = .././tmux/.tmux.conf.local;
    ".config/starship.toml".source = .././shell/starship.toml;
    ".ssh/snowflake_tf.p8".source = config.lib.file.mkOutOfStoreSymlink "${config.sops.secrets."key/cube/snow".path}";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
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
