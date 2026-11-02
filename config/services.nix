{...}: {
  # Home Manager has a launchd branch for ssh-agent, so this stays shared: on
  # Linux the socket lives in $XDG_RUNTIME_DIR, on darwin in
  # $(getconf DARWIN_USER_TEMP_DIR).
  services.ssh-agent.enable = true;
}
