{ config, ... }:
{

  sops.secrets = {
    "ssh/personal/gh".mode = "0600";
    "ssh/personal/contabo/dit".mode = "0600";
    "ssh/personal/contabo/root".mode = "0600";

    "ssh/work/cube/gh".mode = "0600";
    "ssh/work/cube/au".mode = "0600";
    "ssh/work/cube/e2".mode = "0600";
    "ssh/work/cube/cf".mode = "0600";
    "ssh/work/cube/unv_i".mode = "0600";
    "ssh/work/cube/gitlab".mode = "0600";
    "ssh/work/cube/gl".mode = "0600";
    "ssh/work/cube/atl".mode = "0600";
  };

  programs.ssh.matchBlocks = {
    #          ╭──────────────────────────────────────────────────────────╮
    #          │                         Personal                         │
    #          ╰──────────────────────────────────────────────────────────╯
    github = {
      hostname = "github.com";
      user = "git";
      identityFile = "${config.sops.secrets."ssh/personal/gh".path}";
    };
    contabo_main = {
      hostname = "62.146.236.13";
      user = "dit";
      identityFile = "${config.sops.secrets."ssh/personal/contabo/dit".path}";
    };
    contabo_root = {
      hostname = "62.146.236.13";
      user = "root";
      identityFile = "${config.sops.secrets."ssh/personal/contabo/root".path}";
    };
    contabo_sec = {
      hostname = "62.146.233.85";
      user = "root";
      # identityFile = "${config.sops.secrets."ssh/personal/contabo/root".path}";
    };


    #          ╭──────────────────────────────────────────────────────────╮
    #          │                           Work                           │
    #          ╰──────────────────────────────────────────────────────────╯
    # ── Cube ──────────────────────────────────────────────────────────────
    github-cube = {
      hostname = "github.com";
      user = "git";
      identityFile = "${config.sops.secrets."ssh/work/cube/gh".path}";
    };
    gitlab-cube = {
      hostname = "git.internal-app.cube.asia";
      user = "git";
      identityFile = "${config.sops.secrets."ssh/work/cube/gitlab".path}";
    };
    cube-run = {
      hostname = "10.1.29.120";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    };
    cube-e2 = {
      hostname = "52.76.39.210";
      user = "ec2-user";
      port = 2209;
      identityFile = "${config.sops.secrets."ssh/work/cube/e2".path}";
    };
    cube-cf = {
      hostname = "10.1.28.230";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/cf".path}";
    };
    cube-gl = {
      hostname = "10.1.19.17";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/gl".path}";
    };
    cube-atl = {
      hostname = "10.1.26.14";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/atl".path}";
    };
  };

}
