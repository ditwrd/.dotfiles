{ config, pkgs, pkgs-stable, pkgs-master, ... }:
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

    sau = "sudo nala update";
    saupg = "sudo nala upgrade -y";
    sauu = "sau && sudo nala upgrade -y";
    sai = "sudo nala install";

    awsd = "source _awsd";

    lg = "lazygit";
    ld = "lazydocker";

    tf = "terraform";
    tfa = "terraform apply";
    tfyolo = "terraform apply --auto-approve";
    tfp = "terraform plan";
    tfo = "terraform output";
    tfoj = "terraform output -json > outputs.json";
    tfw = "terraform workspace";
    tfws = "terraform workspace select";
    tfwls = "terraform workspace list";

    tg = "terragrunt";
    tga = "terragrunt apply";
    tgyolo = "terragrunt apply --auto-approve";
    tgp = "terragrunt plan";
    tgo = "terragrunt output";
    tgoj = "terragrunt output -json > out.json";

    hm = "home-manager";
    hms = "home-manager switch -b backup";
  };
}
