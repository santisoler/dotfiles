# Enable Powerlevel10k instant prompt
# -----------------------------------
# These lines should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Options section
# ---------------
setopt correct             # Auto correct mistakes
setopt extendedglob        # Extended globbing. Allows using regular expressions with *
setopt nocaseglob          # Case insensitive globbing
setopt rcexpandparam       # Array expension with parameters
setopt nocheckjobs         # Don't warn about running processes when exiting
setopt numericglobsort     # Sort filenames numerically when it makes sense
setopt nobeep              # No beep
setopt appendhistory       # Immediately append history instead of overwriting
setopt histignorealldups   # If a new command is a duplicate, remove the older one
setopt autocd              # if only directory path is entered, cd there.

# Case insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Colored completion (different colors for dirs/files/etc)
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Automatically find new executables in path
zstyle ':completion:*' rehash true
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500
#export EDITOR=/usr/bin/nano
#export VISUAL=/usr/bin/nano
WORDCHARS=${WORDCHARS//\/[&.;]}   # Don't consider certain characters part of the word


# Keybindings section
# -------------------
bindkey -e
bindkey '^[[7~' beginning-of-line                     # Home key
bindkey '^[[H' beginning-of-line                      # Home key
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line      # [Home] - Go to beginning of line
fi
bindkey '^[[8~' end-of-line                           # End key
bindkey '^[[F' end-of-line                            # End key
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line             # [End] - Go to end of line
fi
bindkey '^[[2~' overwrite-mode                        # Insert key
bindkey '^[[3~' delete-char                           # Delete key
bindkey '^[[C'  forward-char                          # Right key
bindkey '^[[D'  backward-char                         # Left key
bindkey '^[[5~' history-beginning-search-backward     # Page up key
bindkey '^[[6~' history-beginning-search-forward      # Page down key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                           #
bindkey '^[Od' backward-word                          #
bindkey '^[[1;5D' backward-word                       #
bindkey '^[[1;5C' forward-word                        #
bindkey '^H' backward-kill-word                       # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                   # Shift+tab undo last action


# Aliases
# -------
alias v="nvim"
alias vim="nvim"
alias cp="cp -i"                          # confirm before overwriting something
alias ls='ls --color'
alias ll="ls --color -lh"                 # ls in list and human readable
alias du="du -h -d 0"                     # disk usage with human readable and depth 0
alias df='df -h'                          # Human-readable sizes
alias free='free -m'                      # Show sizes in MB
alias open='xdg-open'
alias xc='xclip -selection clipboard'     # copy to clipboard using xclip
alias diceware-es='diceware -d " " --no-caps $DICEWARE_ES'
alias lab='tmux new-session -d -s lab; tmux send-keys -t lab "cd $HOME; jupyter-lab --no-browser" Enter'
alias ta="tmux attach -t"
alias remotelab='tmux new-session -d -s remotelab; tmux send-keys -t remotelab "ssh -N -L localhost:9999:localhost:8888 santi@soler.unsj.edu.ar" Enter'
alias serve='tmux new-session -d -s serve; tmux send-keys -t serve "livereload -p 8080 ." Enter'
alias ca='conda activate'
alias cdtop='cd $(git rev-parse --show-toplevel)' # cd to toplevel of git repo


# Theming section
# ---------------
autoload -U compinit colors zcalc
compinit -d
colors

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
# export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r


# Powerlevel theme
# ----------------
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



# Plugins section: Enable fish style features
# -------------------------------------------
# Use syntax highlighting
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Use history substring search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# bind UP and DOWN arrow keys to history substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# pkgfile
if [[ -r /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
    export PKGFILE_PROMPT_INSTALL_MISSING=1
fi


# Init conda
# ----------
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/santi/.anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/santi/.anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/santi/.anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/santi/.anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup


# ---------------
# Conda functions
# ---------------
condaon() {
    if [[ `which python` == "/usr/bin/python" ]]; then
        export PATH=$CONDA_PREFIX/bin:$PATH
    else
        echo "Conda is already on"
    fi
}

condaoff() {
    if [[ `which python` != "/usr/bin/python" ]]; then
        export PATH=`echo $PATH | sed -n -e 's@'"$CONDA_PREFIX"'/bin:@@p'`
    else
        echo "Conda is already off"
    fi
}

cenv () {
read -r -d '' CENV_HELP <<-'EOF'
Usage: cenv [COMMAND] [FILE]

Detect, activate, delete, and update conda environments.
FILE should be a conda .yml environment file.
If FILE is not given, assumes it is environment.yml.
Automatically finds the environment name from FILE.

Commands:

  None     Activates the environment
  da       Deactivate the environment
  rm       Delete the environment
  up       Update the environment

EOF

    envfile="environment.yml"

    # Parse the command line arguments
    if [[ $# -gt 2 ]]; then
        >&2 echo "Invalid argument(s): $@";
        return 1;
    elif [[ $# == 0 ]]; then
        cmd="activate"
    elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "$CENV_HELP";
        return 0;
    elif [[ "$1" == "da" ]]; then
        cmd="deactivate"
    elif [[ "$1" == "rm" ]]; then
        cmd="delete"
        if [[ $# == 2 ]]; then
            envfile="$2"
        fi
    elif [[ "$1" == "up" ]]; then
        cmd="update"
        if [[ $# == 2 ]]; then
            envfile="$2"
        fi
    elif [[ $# == 1 ]]; then
        envfile="$1"
        cmd="activate"
    else
        >&2 echo "Invalid argument(s): $@";
        return 1;
    fi

    # Check if the file exists
    if [[ ! -e "$envfile" ]]; then
        >&2 echo "Environment file not found:" $envfile;
        return 1;
    fi

    # Get the environment name from the yaml file
    envname=$(grep "name: *" $envfile | sed -n -e 's/name: //p')

    # Execute one of these actions: activate, update, delete
    if [[ $cmd == "activate" ]]; then
        conda activate "$envname";
    elif [[ $cmd == "deactivate" ]]; then
        conda deactivate;
    elif [[ $cmd == "update" ]]; then
        >&2 echo "Updating environment:" $envname;
 changeps1: False       conda activate "$envname";
        conda env update -f "$envfile"
    elif [[ $cmd == "delete" ]]; then
        >&2 echo "Removing environment:" $envname;
        conda deactivate;
        conda env remove --name "$envname";
    fi
}


# Activate the conda default environment
# --------------------------------------
if [ -f $HOME/environment.yml ]; then
    cenv $HOME/environment.yml
fi


# Initialize ssh agent
# --------------------
if [ -f ~/.ssh/agent.env ] ; then
    . ~/.ssh/agent.env > /dev/null
    if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
        # echo "Stale agent file found. Spawning new agent… "
        eval `ssh-agent | tee ~/.ssh/agent.env`
    fi
else
    # echo "Starting ssh-agent"
    eval `ssh-agent | tee ~/.ssh/agent.env`
fi

