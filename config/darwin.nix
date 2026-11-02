{
  config,
  pkgs,
  ...
}: {
  # macOS has no pacman list, so the tools the shared shell config and aliases
  # expect come from nix. mise then installs everything listed in
  # shell/mise-config.toml.
  home.packages = with pkgs; [
    atuin
    kitty
    lazygit
    lazydocker
    mise
    starship
    tmux
    zellij
    zoxide
  ];

  # tern looks in ~/Library/Application Support on darwin, while home.nix
  # symlinks its config to ~/.config/tern.
  home.sessionVariables.TERN_CONFIG_DIR = "${config.home.homeDirectory}/.config/tern";
}
