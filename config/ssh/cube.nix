# Cube hosts: ubuntu@ with the shared au key unless a host overrides it.
{
  config,
  lib,
  ...
}: let
  key = name: config.sops.secrets."ssh/work/cube/${name}".path;
  host = hostname: {
    inherit hostname;
    user = "ubuntu";
    identityFile = key "au";
  };
in {
  sops.secrets = lib.genAttrs [
    "ssh/work/cube/gh"
    "ssh/work/cube/au"
    "ssh/work/cube/mc"
    "ssh/work/cube/e2"
    "ssh/work/cube/cf"
    "ssh/work/cube/unv_i"
    "ssh/work/cube/gitlab"
    "ssh/work/cube/gl"
    "ssh/work/cube/atl"
  ] (_: {mode = "0600";});

  programs.ssh.settings = {
    github-cube = {
      hostname = "ssh.github.com";
      user = "git";
      identityFile = key "gh";
      port = 443;
      controlMaster = false;
      identitiesOnly = true;
    };
    gitlab-cube = {
      hostname = "git.internal-app.cube.asia";
      user = "git";
      identityFile = key "gitlab";
    };
    gitlab-cube-proxy =
      {
        hostname = "git.internal-app.cube.asia";
        user = "git";
        identityFile = key "gitlab";
      }
      // {proxyCommand = "nc -X connect -x localhost:1080 %h %p";};

    cube-repo-run = host "10.1.29.120";
    cube-e2 =
      host "52.76.39.210"
      // {
        user = "ec2-user";
        port = 2209;
        identityFile = key "e2";
      };
    cube-cloudflare = host "10.1.28.230" // {identityFile = key "cf";};
    cube-gitlab = host "10.1.19.17" // {identityFile = key "gl";};
    cube-atl = host "10.1.16.239" // {identityFile = key "atl";};

    cube-core-dns = host "10.2.20.121";
    cube-core-dns-legacy = host "10.1.27.122";
    cube-dec-jup = host "10.1.22.171";
    cube-monit = host "10.1.16.50";
    cube-monit-new = host "10.2.22.22";
    cube-ac-air-work = host "10.1.16.27";
    cube-ac-air-work-2 = host "10.1.17.50";
    cube-ac-air-web = host "10.1.27.213";
    cube-ac-hermes-db-prod = host "10.2.50.242";
    cube-py-air-web = host "10.1.17.84";
    cube-py-air-work = host "10.1.24.111";
    cube-py-utils = host "10.1.23.130";
    cube-mo-sqlmesh-post = host "10.2.51.17";
    cube-mo-openmetadata-post = host "10.2.48.193";
    cube-mo-air-post = host "10.1.20.35";
    cube-mo-air-fleet-post = host "10.2.53.150";
    cube-mo-n8n = host "10.1.26.37";
    cube-vpn = host "10.2.18.76";
    cube-vpn-instance-connect = host "localhost" // {port = 2345;};

    cube-metercube-admin-dev = host "10.2.36.201" // {identityFile = key "mc";};
    cube-metercube-admin-staging = host "10.2.34.185" // {identityFile = key "mc";};
    cube-metercube-admin-production = host "10.2.32.166" // {identityFile = key "mc";};
    cube-metercube-db-dev = host "10.2.51.35" // {identityFile = key "mc";};
    cube-metercube-db-production = host "10.2.50.99" // {identityFile = key "mc";};
    cube-metercube-chatbot-dev = host "10.2.36.80" // {identityFile = key "mc";};
    cube-metercube-chatbot-staging = host "10.2.38.45" // {identityFile = key "mc";};
    cube-metercube-chatbot-production = host "10.2.33.223" // {identityFile = key "mc";};
    cube-metercube-app-dev = host "10.2.39.187" // {identityFile = key "mc";};
    cube-metercube-app-staging = host "10.2.34.34" // {identityFile = key "mc";};
    cube-metercube-app-production = host "10.2.37.41" // {identityFile = key "mc";};
    cube-metercube-dmz = host "10.2.0.8";
    cube-metercube-dmz-prod = host "10.2.0.30";
    cube-metercube-gh-runner = host "10.2.18.158";
    cube-metercube-db-dev-tunnel =
      host "10.2.51.35"
      // {
        identityFile = key "mc";
        LocalForward = {
          bind.port = 6432;
          host = {
            address = "localhost";
            port = 5432;
          };
        };
      };
    cube-transactions-2g = host "10.2.52.7";
    cube-faros-openwebui = host "10.2.19.195";
    cube-faros-mcp = host "10.2.16.194";
    cube-faros-db = host "10.2.55.236";
    cube-fleet-persistent-nfs = host "10.2.54.169";
  };
}
