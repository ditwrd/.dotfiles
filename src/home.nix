{ config, pkgs, pkgs-stable, pkgs-master, ... }:

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
    ".tmux.conf".source = .././tmux/.tmux/.tmux.conf;
    ".tmux.local.conf".source = .././tmux/.tmux.conf.local;
    ".zsh_custom".source = .././zsh/custom;
    ".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/personal/.dotfiles/zsh/.p10k.zsh";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
    AWS_PROFILE = "$(cat ${config.home.homeDirectory}/.awsd)";
  };

}
