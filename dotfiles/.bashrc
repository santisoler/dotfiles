# ==================
# Bash configuration
# ==================

# -------------
# Load builtins
# -------------
complete -cf sudo
shopt -s expand_aliases
shopt -s histappend  # enable history appending instead of overwriting

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize


# --------------------
# Load bash-completion
# --------------------
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi


# -----------------------
# Add directories to PATH
# -----------------------
export PATH=$HOME/bin/:$PATH
export PATH="$PATH:$(ruby -e 'print Gem.user_dir' 2> /dev/null)/bin"


# ----------------
# Define variables
# ----------------
export GEM_HOME=$HOME/.gem
export CONDA_PATH=$HOME/.anaconda3


# -------
# Aliases
# -------
alias v="nvim"
alias vim="nvim"
alias cp="cp -i"
alias ls="ls --group-directories-first --color=auto"
alias ll="ls -lh --group-directories-first --color=auto"
alias la="ls -lah --group-directories-first --color=auto"
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias du="du -h -d 0"
alias open='xdg-open'
alias xc='xclip -selection clipboard' # copy to clipboard using xclip

# Run commands in background using tmux
alias ta="tmux attach -t"
alias lab='tmux new-session -d -s lab; tmux send-keys -t lab "cd $HOME; jupyter-lab --no-browser" Enter'
alias remotelab='tmux new-session -d -s remotelab; tmux send-keys -t remotelab "ssh -N -L localhost:9999:localhost:8888 santi@soler.unsj.edu.ar" Enter'
alias serve='tmux new-session -d -s serve; tmux send-keys -t serve "livereload -p 8080 ." Enter'

# Conda aliases
alias ca='conda activate'
alias cdtop='cd $(git rev-parse --show-toplevel)' # cd to toplevel of git repo

# Git aliases
alias gti="git"
alias gi="git"
alias gts="git status"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# ------
# Colors
# ------
# Load dircolors
if type -P dircolors >/dev/null ; then
    if [[ -f ~/.dir_colors ]] ; then
        eval $(dircolors -b ~/.dir_colors)
    elif [[ -f /etc/DIR_COLORS ]] ; then
        eval $(dircolors -b /etc/DIR_COLORS)
    fi
fi

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;30;44m'
export LESS_TERMCAP_ue=$'\E[01;0m'
export LESS_TERMCAP_us=$'\E[01;36m'


# ----------------------
# Make the prompt pretty
# ----------------------
if [ -f ~/.bash/prompt.sh ]; then
    source ~/.bash/prompt.sh
fi


# --------------------------
# Load some useful functions
# --------------------------
if [ -f ~/.bash/functions.sh ]; then
    source ~/.bash/functions.sh
fi


# --------------------
# Initialize ssh agent
# --------------------
if [ -f ~/.ssh/agent.env ] ; then
    . ~/.ssh/agent.env > /dev/null
    if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
        eval `ssh-agent | tee ~/.ssh/agent.env`
    fi
else
    eval `ssh-agent | tee ~/.ssh/agent.env`
fi


# ----------------
# Initialize conda
# ----------------
# Setup and activate the conda package manager
if [ -f $CONDA_PATH/etc/profile.d/conda.sh ]; then
    source "$CONDA_PATH/etc/profile.d/conda.sh"
    conda activate
fi

# Activate the conda default environment
if [ -f $HOME/environment.yml ]; then
    cenv $HOME/environment.yml
fi
