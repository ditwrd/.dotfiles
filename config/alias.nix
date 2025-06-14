{ config, ... }:
{
  home.shellAliases = {
    vd = "z dot && nvim";
    vs = "z ssh && nvim ${config.home.homeDirectory}/.ssh";
    v = "nvim";

    cdd = "cd ..";
    cddd = "cd ../..";

    tm = "tmux";
    tma = "tmux attach -t";

    st = "speedtest";

    x = "exit";

    awsd = "source _awsd";

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

    hm = "home-manager";
    hms = "home-manager switch -b backup";

    wcc = "warp-cli connect";
    wcd = "warp-cli disconnect";
    po = "sudo cpupower frequency-set -g powersave && powerprofilesctl set power-saver";
    pe = "sudo cpupower frequency-set -g performance && powerprofilesctl set performance";

    y = "yay";

    ggcla = "gcloud config configurations activate";



  };
}
