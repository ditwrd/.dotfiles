{
  config,
  pkgs,
  attrName,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/projects/personal/.dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in {
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
    zoxide
  ];

  # Bare `home-manager switch` infers $USER as the flake attribute, which only
  # matches this account's exported name; name it explicitly anyway.
  home.shellAliases = {
    hms = "home-manager switch -b backup --flake ${config.home.homeDirectory}/projects/personal/.dotfiles#${attrName}";
  };

  # tern looks in ~/Library/Application Support on darwin, while home.nix
  # symlinks its config to ~/.config/tern.
  home.sessionVariables.TERN_CONFIG_DIR = "${config.home.homeDirectory}/.config/tern";

  # The keyboard on macOS is Karabiner-Elements, not kanata: kanata's macOS
  # backend needs a root grabber talking to the Karabiner VirtualHIDDevice
  # daemon, and its pinned driver protocol (v6.2.0) is rejected by the daemon
  # that Karabiner-Elements 16.3.0 installs (v8.5.0).  The two cannot share one
  # machine.  Linux keeps kanata (hypr/kanata.service + kanata/kanata.kbd).
  #
  # Karabiner-Elements itself is installed with the Homebrew cask, not
  # pkgs.karabiner-elements: nixpkgs pins 15.7.0 and a store-path app bundle
  # would change its path on every switch, invalidating the TCC grants and the
  # DriverKit system extension.  The cask installs 16.3.0 in /Applications.
  # See karabiner/README.md for the one-time permission steps.
  #
  # The whole directory is linked, not karabiner.json: Karabiner-Elements
  # watches dirname(karabiner.json) with FSEvents and rewrites the file
  # atomically (new inode + rename), so a symlink to the file itself is neither
  # detected nor preserved.  The target must also be out-of-store, because KE
  # writes karabiner.json, assets/ and automatic_backups/ into this directory
  # and a /nix/store path is read-only.  The resolved target is stable across
  # switches, so the watcher is not re-pointed on every activation.
  home.file.".config/karabiner".source = link "karabiner";
}
