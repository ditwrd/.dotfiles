# Personal hosts and the keys they need. Everything a company needs to manage
# its ssh lives in its own file here.
{
  config,
  lib,
  ...
}: let
  key = name: config.sops.secrets."ssh/personal/${name}".path;
in {
  sops.secrets = lib.genAttrs [
    "ssh/personal/gh"
    "ssh/personal/forgejo_local"
    "ssh/personal/contabo/workspace_dit"
    "ssh/personal/contabo/appspace_dit"
    "ssh/personal/deploycamp/deploycamp"
  ] (_: {mode = "0600";});

  programs.ssh.settings = {
    github = {
      hostname = "ssh.github.com";
      user = "git";
      identityFile = key "gh";
      port = 443;
      controlMaster = false;
      identitiesOnly = true;
    };
    workspace_dit = {
      hostname = "62.171.181.195";
      user = "dit";
      identityFile = key "contabo/workspace_dit";
    };
    # Root on the same box is reached with the agent, so no key is pinned.
    appspace_root = {
      hostname = "62.146.233.85";
      user = "root";
    };
    appspace_dit = {
      hostname = "62.146.233.85";
      user = "dit";
      identityFile = key "contabo/appspace_dit";
    };
  };
}
