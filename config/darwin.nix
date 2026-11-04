{
  config,
  pkgs,
  ...
}: let
  kanataConfig = "${config.home.homeDirectory}/.config/kanata/kanata.kbd";
in {
  # macOS has no pacman list, so the tools the shared shell config and aliases
  # expect come from nix. mise then installs everything listed in
  # shell/mise-config.toml. kanata is here for the daemon: the plist runs a
  # copy of this binary, and `command -v kanata` is how the copy is made.
  home.packages = with pkgs; [
    atuin
    # Tiling WM, mirroring the Linux Hyprland setup.  Caveat: home-manager links
    # the store-built AeroSpace.app into ~/Applications/Home Manager Apps, so the
    # bundle path changes on every switch while macOS TCC (Accessibility) and the
    # start-at-login SMAppService item key off that path - permissions may need
    # re-granting after an upgrade.  If that gets annoying the sanctioned
    # alternative is the Homebrew cask in /Applications, but only one of the two.
    aerospace
    kanata
    kitty
    lazygit
    lazydocker
    mise
    starship
    tmux
    zellij
    zoxide
  ];

  # Bare `home-manager switch` infers $USER and would pick the Linux `dit`
  # attribute, so the mac one has to be named on the command line.
  home.shellAliases = {
    hms = "home-manager switch -b backup --flake ${config.home.homeDirectory}/projects/personal/.dotfiles#dit@mac";

    # Start if stopped, restart if loaded: bootstrap refuses a label that is
    # already loaded, and kickstart cannot reach one that was booted out.
    # Stop is bootout and not `kill SIGTERM`, because KeepAlive relaunches a
    # job that died from a signal. Restarting is also how an edited keymap is
    # picked up.
    ksa = "sudo launchctl bootstrap system /Library/LaunchDaemons/dev.kanata.kanata.plist || sudo launchctl kickstart -k system/dev.kanata.kanata";
    kst = "sudo launchctl bootout system/dev.kanata.kanata";
  };

  # tern looks in ~/Library/Application Support on darwin, while home.nix
  # symlinks its config to ~/.config/tern.
  home.sessionVariables.TERN_CONFIG_DIR = "${config.home.homeDirectory}/.config/tern";

  # kanata's macOS backend grabs the keyboard through the Karabiner
  # VirtualHIDDevice driver and talks to its daemon over IPC under
  # /Library/Application Support/org.pqrs/tmp/rootonly (mode 700, root), so it
  # has to run as root. home-manager's launchd.agents writes a USER LaunchAgent
  # and cannot; the daemon is a root LaunchDaemon instead. The plist is tracked
  # in kanata/dev.kanata.kanata.plist, which also carries the one-time macOS
  # prerequisites (driver, VHID daemon, TCC grants) and the install commands.
  #
  # It runs /usr/local/libexec/kanata, a staged copy of the profile binary, and
  # not a store or profile path: `home-manager switch` must not change the
  # executable behind an existing TCC grant, so upgrading kanata is a
  # deliberate re-copy. A symlink under $HOME was rejected because a root
  # daemon executing a user writable path is a local privilege escalation
  # surface.
  home.file.".config/kanata/dev.kanata.kanata.plist".text =
    builtins.replaceStrings ["@KANATA_CFG@"] [kanataConfig]
    (builtins.readFile ../kanata/dev.kanata.kanata.plist);
}
