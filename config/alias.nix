{ config, ... }:
{
  home.shellAliases = {
    vd = "cd dot && nvim";
    vs = "cd ssh && nvim ${config.home.homeDirectory}/.ssh";
    v = "nvim";

    cdd = "cd ..";
    cddd = "cd ../..";


    st = "speedtest";

    x = "exit";

    # awsd = "source _awsd";

    lg = "lazygit";
    ld = "lazydocker";

    tf = "terraform";
    tfa = "terraform apply";
    tfyolo = "terraform apply --auto-approve";
    tfp = "terraform plan";
    tfo = "terraform output";
    tfoj = "terraform output -json > out.json";
    tfw = "terraform workspace";
    tfws = "terraform workspace select";
    tfwls = "terraform workspace list";

    tg = "terragrunt";
    tga = "terragrunt apply";
    tgyolo = "terragrunt apply --auto-approve";
    tgp = "terragrunt plan";
    tgo = "terragrunt output";
    tgoj = "terragrunt output -json > out.json";
    tgf = "terragrunt hclfmt";
    tgnuke = "terragrunt destroy --auto-approve";
    tgd = "terragrunt destroy";
    tgi = "terragrunt init";
    tgr = "tg render --json --write";

    ils = "export HTTP_PROXY=http://127.0.0.1:10080; export HTTPS_PROXY=http://127.0.0.1:10080; export AWS_CA_BUNDLE=~/.iamlive/ca.pem";
    il = "iamlive --set-ini --mode proxy --sort-alphabetical";
    ilo = "iamlive --set-ini --mode proxy --output-file policy.json --sort-alphabetical";


    tfd = "terraform-docs md table . > README.md";
    acp = "aws configure --profile";
    asl = "aws sso login";
    ad = "awsd";

    hm = "home-manager";
    hms = "home-manager switch -b backup";

    wcc = "warp-cli connect";
    wcd = "warp-cli disconnect";
    wcs="warp-cli status";

    dcc = "export HTTPS_PROXY=http://localhost:1080";
    dcd = "unset HTTPS_PROXY";

    po = "powerprofilesctl set power-saver";
    pb = "powerprofilesctl set balanced";
    pe = "powerprofilesctl set performance";

    y = "yay";

    ggcla = "gcloud config configurations activate";

    npm =  "bun";
    npx =  "bunx";

    p = "pwd";
    b = "battop";
    ksa = "sudo systemctl start kanata";
    kst = "sudo systemctl stop kanata";
    bt="bluetui";
    l="p && ls -lah";


    o="omp";
    gc="omp -p /commit";
    mlo="mise ls-remote github:can1357/oh-my-pi --minimum-release-age=0";
    mlh="mise ls-remote herdr --minimum-release-age=0";
    mlr="mise ls-remote";


    # from atuin history analysis
    k = "kubectl";
    u = "uv";
    ur = "uv run";
    us = "uv sync";
    bp = "btop";
    nt = "nmtui";
    sc = "systemctl";
    yy = "yes | y";
    gt = "go test ./...";
    m = "mise";
    mi = "mise install";
    me = "mise env";
    mug = "mise use -g";
      
  };
}
