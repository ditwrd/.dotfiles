typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
zmodload zsh/zprof


# BEGIN P10K INSTANT PROMPT ANSIBLE MANAGED BLOCK
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# END P10K INSTANT PROMPT ANSIBLE MANAGED BLOCK
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

zstyle ':omz:update' mode auto      # update automatically without asking
plugins=(zsh-autoswitch-conda zshfl z zsh-autosuggestions fzf)

source $ZSH/oh-my-zsh.sh

# User configuration
# Custom Aliases
alias vz="nvim ~/.zshrc"
alias voz="nvim ~/.oh-my-zsh"
alias vd="z dot && nvim"
alias vs="z ssh && nvim ~/.ssh"
alias v="nvim"

alias rls='ls'
# alias lsc='colorls -lA --sd'
# alias ls='colorls -a --sd'

alias cdh='cd ~'
alias cdd="cd .."
alias cl="clear"

alias tm="tmux"
alias tma="tmux attach -t"
alias st="speedtest"
alias cda="conda activate"
alias lg="lazygit"
alias ld="lazydocker"
alias x="exit"
alias sau="sudo nala update"
alias saupg="sudo nala upgrade -y"
alias sauu="sau && sudo nala upgrade -y"
alias sai="sudo nala install"

alias dsp="docker system prune"
alias pnx="pnpm nx"

alias dacli='docker run --rm -it -v $(pwd):/ansible --workdir=/ansible willhallonline/ansible:latest /bin/sh'
alias dacmd='docker run --rm -it -v $(pwd):/ansible --workdir=/ansible willhallonline/ansible:latest '

alias awsd="source _awsd"
source _awsd_autocomplete
export AWS_PROFILE=$(cat ~/.awsd)
alias tf='terraform'
alias tfa='terraform apply'
alias tfyolo='terraform apply --auto-approve'
alias tfp='terraform plan'
alias tfo='terraform output'
alias tfoj='terraform output -json > outputs.json'
alias tfw='terraform workspace'
alias tfws='terraform workspace select'
alias tfwls='terraform workspace list'
alias mp='multipass'
alias mpsh='multipass shell'


# Custom export
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/.gem:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin/flutter/bin:$PATH"
export CONDA_AUTO_ACTIVATE_BASE=false

# Auto gitlab ssh-add
eval `ssh-agent -s` &>/dev/null
ssh-add ~/.ssh/gitlab &>/dev/null
ssh-add ~/.ssh/github &>/dev/null

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/dit/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/dit/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/dit/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/dit/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Start Docker daemon automatically when logging in if not running.
RUNNING=`ps aux | grep dockerd | grep -v grep`


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

# BEGIN P10K CONFIG FILE ANSIBLE MANAGED BLOCK
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# END P10K CONFIG FILE ANSIBLE MANAGED BLOCK

# pnpm
export PNPM_HOME="/home/dit/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
fpath=(~/.zsh.d/ $fpath)

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/snap/bin/

export FLYCTL_INSTALL="/home/dit/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# Load pyenv automatically by appending
# the following to
# ~/.bash_profile if it exists, otherwise ~/.profile (for login shells)
# and ~/.bashrc (for interactive shells) :

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Restart your shell for the changes to take effect.

# Load pyenv-virtualenv automatically by adding
# the following to ~/.bashrc:

eval "$(pyenv virtualenv-init -)"


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
