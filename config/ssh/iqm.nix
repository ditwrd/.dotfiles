# IQM / Superpos hosts: ubuntu@ with one shared key. A new company gets its own
# file like this one, with its own key and its own conventions.
{config, ...}: let
  key = config.sops.secrets."ssh/freelance/iqm/app".path;
  host = hostname: {
    inherit hostname;
    user = "ubuntu";
    identityFile = key;
  };
  forward = bind: target: {
    bind.port = bind;
    host = {
      address = "localhost";
      port = target;
    };
  };
in {
  sops.secrets."ssh/freelance/iqm/app".mode = "0600";

  programs.ssh.settings = {
    iqm_app_dev = host "35.219.87.146";
    iqm_db_dev = host "10.10.20.2" // {proxyJump = "iqm_app_dev";};

    superpos_app_dev = host "35.219.32.146" // {LocalForward = forward 9999 9000;};
    superpos_db_dev =
      host "10.10.20.2"
      // {
        proxyJump = "superpos_app_dev";
        checkHostIP = false;
      };
    superpos_planka_dev = host "35.219.1.120";
    superpos_planka_db_dev =
      host "10.10.20.3"
      // {
        proxyJump = "superpos_planka_dev";
        checkHostIP = false;
      };

    superpos_app_prod =
      host "35.219.35.177"
      // {
        LocalForward = [(forward 9999 9000) (forward 3333 3000)];
      };
    superpos_app_prod_repl =
      host "35.219.53.164"
      // {
        LocalForward = [(forward 9999 9000) (forward 3333 3000)];
      };
    superpos_db_prod =
      host "10.10.20.5"
      // {
        proxyJump = "superpos_app_prod";
        checkHostIP = false;
      };
    superpos_db_prod_repl =
      host "10.10.20.2"
      // {
        proxyJump = "superpos_app_prod_repl";
        checkHostIP = false;
      };
    superpos_planka_prod = host "35.219.3.112";
    superpos_planka_prod_repl = host "35.219.5.182";
    superpos_planka_db_prod =
      host "10.10.20.4"
      // {
        proxyJump = "superpos_planka_prod";
        checkHostIP = false;
      };
  };
}
