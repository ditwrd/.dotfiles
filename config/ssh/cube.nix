# Cube hosts: ubuntu@ with the shared au key unless a host overrides it.
#
# Internal addresses are not in git: each host's address lives in the sops key
# `ssh/work/cube/addresses/<host>`, and sops-nix renders those into the
# ssh_config fragment included below. Only public hostnames are written here.
{
  config,
  lib,
  ...
}: let
  key = name: config.sops.secrets."ssh/work/cube/${name}".path;
  host = {
    user = "ubuntu";
    identityFile = key "au";
  };

  hosts = {
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

    cube-repo-run = host;
    cube-e2 =
      host
      // {
        user = "ec2-user";
        port = 2209;
        identityFile = key "e2";
      };
    cube-cloudflare = host // {identityFile = key "cf";};
    cube-gitlab = host // {identityFile = key "gl";};
    cube-atl = host // {identityFile = key "atl";};

    cube-core-dns = host;
    cube-core-dns-legacy = host;
    cube-dec-jup = host;
    cube-monit = host;
    cube-monit-new = host;
    cube-ac-air-work = host;
    cube-ac-air-work-2 = host;
    cube-ac-air-web = host;
    cube-ac-hermes-db-prod = host;
    cube-py-air-web = host;
    cube-py-air-work = host;
    cube-py-utils = host;
    cube-mo-sqlmesh-post = host;
    cube-mo-openmetadata-post = host;
    cube-mo-air-post = host;
    cube-mo-air-fleet-post = host;
    cube-mo-n8n = host;
    cube-vpn = host;
    cube-vpn-instance-connect = host // {hostname = "localhost";} // {port = 2345;};

    cube-metercube-admin-dev = host // {identityFile = key "mc";};
    cube-metercube-admin-staging = host // {identityFile = key "mc";};
    cube-metercube-admin-production = host // {identityFile = key "mc";};
    cube-metercube-db-dev = host // {identityFile = key "mc";};
    cube-metercube-db-production = host // {identityFile = key "mc";};
    cube-metercube-chatbot-dev = host // {identityFile = key "mc";};
    cube-metercube-chatbot-staging = host // {identityFile = key "mc";};
    cube-metercube-chatbot-production = host // {identityFile = key "mc";};
    cube-metercube-app-dev = host // {identityFile = key "mc";};
    cube-metercube-app-staging = host // {identityFile = key "mc";};
    cube-metercube-app-production = host // {identityFile = key "mc";};
    cube-metercube-dmz = host;
    cube-metercube-dmz-prod = host;
    cube-metercube-gh-runner = host;
    cube-metercube-db-dev-tunnel =
      host
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
    cube-transactions-2g = host;
    cube-faros-openwebui = host;
    cube-faros-mcp = host;
    cube-faros-db = host;
    cube-fleet-persistent-nfs = host;
  };

  # Hosts with a public hostname or a loopback address need no sops entry.
  addressless = [
    "github-cube"
    "gitlab-cube"
    "gitlab-cube-proxy"
    "cube-vpn-instance-connect"
  ];
  addressHosts = builtins.filter (n: !builtins.elem n addressless) (builtins.attrNames hosts);
  address = name: "ssh/work/cube/addresses/${name}";
in {
  sops.secrets = lib.genAttrs ([
      "ssh/work/cube/gh"
      "ssh/work/cube/au"
      "ssh/work/cube/mc"
      "ssh/work/cube/e2"
      "ssh/work/cube/cf"
      "ssh/work/cube/unv_i"
      "ssh/work/cube/gitlab"
      "ssh/work/cube/gl"
      "ssh/work/cube/atl"
    ]
    ++ map address addressHosts)
  (_: {mode = "0600";});

  sops.templates."cube-addresses" = {
    content =
      lib.concatMapStringsSep "\n" (name: ''
        Host ${name}
          HostName ${config.sops.placeholder.${address name}}
      '')
      addressHosts;
    mode = "0400";
  };

  programs.ssh.includes = [config.sops.templates."cube-addresses".path];

  programs.ssh.settings = hosts;
}
