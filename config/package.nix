{ pkgs, pkgs-stable, pkgs-master, ... }:

{
  home.packages = [
    #          ╭──────────────────────────────────────────────────────────╮
    #          │                         Terminal                         │
    #          ╰──────────────────────────────────────────────────────────╯
    pkgs.zsh-powerlevel10k
    #          ╭──────────────────────────────────────────────────────────╮
    #          │                    Nvim Dependencies                     │
    #          ╰──────────────────────────────────────────────────────────╯

    # ── Misc ──────────────────────────────────────────────────────────────
    pkgs.ripgrep
    pkgs.lazygit

    # ── LSP ───────────────────────────────────────────────────────────────
    pkgs.nixd
    pkgs.alejandra
    pkgs.deadnix
    pkgs.statix


    #          ╭──────────────────────────────────────────────────────────╮
    #          │                       DevOps Tools                       │
    #          ╰──────────────────────────────────────────────────────────╯

    # ── Cloud CLI ─────────────────────────────────────────────────────────
    # pkgs.awscli2
    pkgs.google-cloud-sdk

    # ── IaC ───────────────────────────────────────────────────────────────
    pkgs.ansible
    pkgs.terraform
    pkgs.terraform-docs
    pkgs.terragrunt

    # ── Container ─────────────────────────────────────────────────────────
    pkgs.lazydocker
    pkgs.docker
    pkgs.colima

    # ── k8s ───────────────────────────────────────────────────────────────
    pkgs.k9s
    pkgs.kubectl
    pkgs.kubeseal
    pkgs.kubernetes-helm
    pkgs.arkade

    # ── Software Tools ────────────────────────────────────────────────────
    pkgs.git
    pkgs.volta
    pkgs.go
    pkgs.uv
    pkgs.rustup

    pkgs.jq
    pkgs.yq

    #          ╭──────────────────────────────────────────────────────────╮
    #          │                           Misc                           │
    #          ╰──────────────────────────────────────────────────────────╯
    pkgs.sops
    pkgs.age
    pkgs.presenterm

  ];
}
