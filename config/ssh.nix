{ config, ... }:
{

  sops.secrets = {
    "ssh/personal/gh".mode = "0600";
    "ssh/personal/contabo/dit".mode = "0600";
    "ssh/personal/contabo/root".mode = "0600";
    "ssh/personal/contabo/dit_sec".mode = "0600";
    "ssh/personal/contabo/root_sec".mode = "0600";

    "ssh/freelance/iqm/app".mode = "0600";

    "ssh/work/cube/gh".mode = "0600";
    "ssh/work/cube/au".mode = "0600";
    "ssh/work/cube/e2".mode = "0600";
    "ssh/work/cube/cf".mode = "0600";
    "ssh/work/cube/unv_i".mode = "0600";
    "ssh/work/cube/gitlab".mode = "0600";
    "ssh/work/cube/gl".mode = "0600";
    "ssh/work/cube/atl".mode = "0600";
    "aws/config".mode = "0600";
    "aws/credentials".mode = "0600";
    "k8s/config".mode = "0600";

    "env/avante".mode = "0600";
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
    contabo_sec_root = {
      hostname = "62.146.233.85";
      user = "root";
      identityFile = "${config.sops.secrets."ssh/personal/contabo/root_sec".path}";
    };
    contabo_sec = {
      hostname = "62.146.233.85";
      user = "dit";
      identityFile = "${config.sops.secrets."ssh/personal/contabo/dit_sec".path}";
    };

    #          ╭──────────────────────────────────────────────────────────╮
    #          │                        Freelance                         │
    #          ╰──────────────────────────────────────────────────────────╯

    iqm_app_dev = {
      hostname = "35.219.87.146";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/freelance/iqm/app".path}";
    };
    iqm_db_dev = {
      hostname = "10.10.20.2";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/freelance/iqm/app".path}";
      proxyJump = "iqm_app_dev";
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
    cube-repo-run = {
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
    cube-cloudflare = {
      hostname = "10.1.28.230";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/cf".path}";
    };
    cube-gitlab = {
      hostname = "10.1.19.17";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/gl".path}";
    };
    cube-atlantis = {
      hostname = "10.1.16.239";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/atl".path}";
    };
    cube-dec-jup = {
      hostname = "10.1.22.171";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    };
    cube-monit = {
      hostname = "10.1.16.50";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    };
    cube-ac-air-work = {
      hostname = "10.1.16.27";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    };
    cube-ac-air-web = {
      hostname = "10.1.27.213";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    };
    cube-py-air-web = {
      hostname = "10.1.17.84";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    };
    cube-py-air-work = {
      hostname = "10.1.24.111";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    };
    cube-mo-air-post = {
      hostname = "10.1.20.35";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    };
    cube-mo-n8n = {
      hostname = "10.1.26.37";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    };

  };

}
