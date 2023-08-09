zmodload zsh/zprof


# BEGIN P10K INSTANT PROMPT ANSIBLE MANAGED BLOCK
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# END P10K INSTANT PROMPT ANSIBLE MANAGED BLOCK
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

zstyle ':omz:update' mode auto      # update automatically without asking
plugins=(zsh-autoswitch-conda zshfl auto-color-ls z zsh-autosuggestions fzf)

source $ZSH/oh-my-zsh.sh
source $(dirname $(gem which colorls))/tab_complete.sh

# User configuration
# Custom Aliases
alias vz="nvim ~/.zshrc"
alias voz="nvim ~/.oh-my-zsh"
alias vd="nvim ~/dotfiles"
alias vc="nvim ~/.ssh/config"
alias v="nvim"

alias lsc='colorls -lA --sd'
alias ls='colorls -a --sd'

alias cdh='cd ~'
alias code="code-insiders ."
alias cdd="cd .."
alias cl="clear"

alias tm="tmux"
alias tma="tmux attach -t"
alias st="speedtest"
alias cda="conda activate"
alias lg="lazygit"
alias ld="lazydocker"
alias x="exit"

alias dsp="docker system prune"
alias pnx="pnpm nx"

alias dacli='docker run --rm -it -v $(pwd):/ansible --workdir=/ansible willhallonline/ansible:latest /bin/sh'
alias dacmd='docker run --rm -it -v $(pwd):/ansible --workdir=/ansible willhallonline/ansible:latest '

alias awsd="source _awsd"
alias tf='terraform'


# Custom export
export GOROOT=/usr/local/go-1.18.3
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export PATH=$HOME/.gem:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin/flutter/bin:$PATH"
export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"
export PATH="$PATH:/home/adit/cloud-sql-proxy"
export PATH="$PATH:/usr/local/texlive/2023/bin/x86_64-linux"
export PATH="$PATH:/mnt/c/Users/adity/Downloads/SumatraPDF.exe"
export CONDA_AUTO_ACTIVATE_BASE=false
export FLYCTL_INSTALL="/home/adit/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# Auto gitlab ssh-add
eval `ssh-agent -s` &>/dev/null
ssh-add ~/.ssh/id_ed25519_gitlab &>/dev/null

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/ditw11/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/ditw11/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/ditw11/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/ditw11/miniconda3/bin:$PATH"
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
export PNPM_HOME="/home/ditw11/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

[[ -s "/home/ditw11/.gvm/scripts/gvm" ]] && source "/home/ditw11/.gvm/scripts/gvm"
fpath=(~/.zsh.d/ $fpath)
