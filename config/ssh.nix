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
    "ssh/work/cube/mc".mode = "0600";
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
    superpos_app_dev = {
      hostname = "35.219.32.146";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/freelance/iqm/app".path}";
    };
    superpos_db_dev = {
      hostname = "10.10.20.2";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/freelance/iqm/app".path}";
      proxyJump = "superpos_app_dev";
      checkHostIP = false;
    };
    superpos_planka_dev = {
      hostname = "35.219.1.120";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/freelance/iqm/app".path}";
    };
    
    superpos_planka_db_dev = {
      hostname = "10.10.20.3";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/freelance/iqm/app".path}";
      proxyJump = "superpos_planka_dev";
      checkHostIP = false;
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
    cube-monit-new = {
      hostname = "10.2.22.22";
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
    cube-vpn = {
      hostname = "10.2.18.76";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    };
    cube-vpn-instance-connect = {
      hostname = "localhost";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
      port = 2345;
    };
    cube-metercube-admin-dev = {
      hostname = "10.2.36.201";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/mc".path}";
    };
    cube-metercube-admin-staging = {
      hostname = "10.2.34.185";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/mc".path}";
    };
    cube-metercube-admin-production = {
      hostname = "10.2.32.166";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/mc".path}";
    };
    cube-metercube-db-dev = {
      hostname = "10.2.51.35";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/mc".path}";
    };
    cube-metercube-db-production = {
      hostname = "10.2.50.99";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/mc".path}";
    };
    cube-metercube-app-dev = {
      hostname = "10.2.39.187";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/mc".path}";
    };
    cube-metercube-app-staging = {
      hostname = "10.2.34.34";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/mc".path}";
    };
    cube-metercube-app-production = {
      hostname = "10.2.37.41";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/mc".path}";
    };

    cube-metercube-dmz = {
      hostname = "10.2.0.8";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    };
    cube-metercube-dmz-prod = {
      hostname = "10.2.0.30";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    };
    cube-metercube-gh-runner = {
      hostname = "10.2.18.158";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    };
    cube-metercube-db-dev-tunnel = {
      hostname = "10.2.51.35";
      user = "ubuntu";
      identityFile = "${config.sops.secrets."ssh/work/cube/mc".path}";
      localForwards = [
        {
          bind = {
            port = 6432;
          };
          host = {
            port = 5432;
            address = "localhost";
          };
        }
      ];

    };
    # cube-metercube-gh-runner-tunnel = {
    #   hostname = "10.2.18.158";
    #   user = "ubuntu";
    #   identityFile = "${config.sops.secrets."ssh/work/cube/au".path}";
    #   localForwards = [
    #     {
    #       bind = {
    #         port = 3000;
    #       };
    #       host = {
    #         port = 8080;
    #         address = "localhost";
    #       };
    #     }
    #   ];
    #
    # };

    # Host cube-metercube-db-dev-tunnel
    #   HostName 10.2.51.35
    #   User ubuntu
    #   IdentityFile ~/.ssh/key
    #   LocalForward 6432:localhost:5432
    # ServerAliveInterval 30
    # ServerAliveCountMax 3



  };

}
