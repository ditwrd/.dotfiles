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
export PATH="/usr/local/bin/flutter/bin:$PATH"
export CONDA_AUTO_ACTIVATE_BASE=false
export PATH="$HOME/.local/bin:$PATH"

# Auto gitlab ssh-add
eval `ssh-agent -s` &>/dev/null
ssh-add ~/.ssh/gitlab &>/dev/null
ssh-add ~/.ssh/github &>/dev/null
ssh-add ~/.ssh/github_cube &>/dev/null

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
export PATH="/home/dit/.pixi/bin:$PATH"
eval "$(pixi completion --shell zsh)"
source "$HOME/.rye/env"

#compdef terraform-docs
compdef _terraform-docs terraform-docs

# zsh completion for terraform-docs                       -*- shell-script -*-

__terraform-docs_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_terraform-docs()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16
    local shellCompDirectiveKeepOrder=32

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace keepOrder
    local -a completions

    __terraform-docs_debug "\n========= starting completion logic =========="
    __terraform-docs_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __terraform-docs_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __terraform-docs_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., terraform-docs -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __terraform-docs_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __terraform-docs_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __terraform-docs_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __terraform-docs_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __terraform-docs_debug "No directive found.  Setting do default"
        directive=0
    fi

    __terraform-docs_debug "directive: ${directive}"
    __terraform-docs_debug "completions: ${out}"
    __terraform-docs_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __terraform-docs_debug "Completion received error. Ignoring completions."
        return
    fi

    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}
    local startIndex=$((${#activeHelpMarker}+1))
    local hasActiveHelp=0
    while IFS='\n' read -r comp; do
        # Check if this is an activeHelp statement (i.e., prefixed with $activeHelpMarker)
        if [ "${comp[1,$endIndex]}" = "$activeHelpMarker" ];then
            __terraform-docs_debug "ActiveHelp found: $comp"
            comp="${comp[$startIndex,-1]}"
            if [ -n "$comp" ]; then
                compadd -x "${comp}"
                __terraform-docs_debug "ActiveHelp will need delimiter"
                hasActiveHelp=1
            fi

            continue
        fi

        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab="$(printf '\t')"
            comp=${comp//$tab/:}

            __terraform-docs_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    # Add a delimiter after the activeHelp statements, but only if:
    # - there are completions following the activeHelp statements, or
    # - file completion will be performed (so there will be choices after the activeHelp)
    if [ $hasActiveHelp -eq 1 ]; then
        if [ ${#completions} -ne 0 ] || [ $((directive & shellCompDirectiveNoFileComp)) -eq 0 ]; then
            __terraform-docs_debug "Adding activeHelp delimiter"
            compadd -x "--"
            hasActiveHelp=0
        fi
    fi

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __terraform-docs_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveKeepOrder)) -ne 0 ]; then
        __terraform-docs_debug "Activating keep order."
        keepOrder="-V"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __terraform-docs_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __terraform-docs_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __terraform-docs_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __terraform-docs_debug "Calling _describe"
        if eval _describe $keepOrder "completions" completions $flagPrefix $noSpace; then
            __terraform-docs_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __terraform-docs_debug "_describe did not find completions."
            __terraform-docs_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __terraform-docs_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __terraform-docs_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_terraform-docs" ]; then
    _terraform-docs
fi

