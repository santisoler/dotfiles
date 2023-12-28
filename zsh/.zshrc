# =================
# zsh configuration
# =================
#
# Based on Manjaro zsh configuration files
#
#
# Define default EDITOR
export EDITOR=/usr/local/bin/nvim


# -------
# Options
# -------
setopt correct            # Auto correct mistakes
setopt extendedglob       # Extended globbing. Allows using regular expressions with *
setopt nocaseglob         # Case insensitive globbing
setopt rcexpandparam      # Array expension with parameters
setopt nocheckjobs        # Don't warn about running processes when exiting
setopt numericglobsort    # Sort filenames numerically when it makes sense
setopt nobeep             # No beep
setopt appendhistory      # Immediately append history instead of overwriting
setopt histignorealldups  # If a new command is a duplicate, remove the older one
setopt autocd             # if only directory path is entered, cd there.
setopt inc_append_history # save commands are added to the history immediately, otherwise only when shell exits.

HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
WORDCHARS=${WORDCHARS//\/[&.;]} # Don't consider certain characters part of the word


# ---------------
# Auto completion
# ---------------
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' menu select                        # higlight selection on completion
zstyle ':completion:*' rehash true                        # automatically find new executables in path

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# allow to use shift tab in completion list (needs to load complist)
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete

# -----------
# Keybindings
# -----------
# bindkey -e                                         # Use emacs keybindings
bindkey -v                                         # Use vim keybindings
bindkey '^[[7~' beginning-of-line                  # Home key
bindkey '^[[H' beginning-of-line                   # Home key
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line   # [Home] - Go to beginning of line
fi
bindkey '^[[8~' end-of-line                        # End key
bindkey '^[[F' end-of-line                         # End key
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line          # [End] - Go to end of line
fi
bindkey '^[[2~' overwrite-mode                     # Insert key
bindkey '^[[3~' delete-char                        # Delete key
bindkey '^[[C'  forward-char                       # Right key
bindkey '^[[D'  backward-char                      # Left key
bindkey '^[[5~' history-beginning-search-backward  # Page up key
bindkey '^[[6~' history-beginning-search-forward   # Page down key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                        #
bindkey '^[Od' backward-word                       #
bindkey '^[[1;5D' backward-word                    #
bindkey '^[[1;5C' forward-word                     #
bindkey '^H' backward-kill-word                    # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                # Shift+tab undo last action


# ----------------
# Define variables
# ----------------
# export GEM_HOME=$HOME/.gem

# -------
# Aliases
# -------
# Aliases for daily used tools
alias v="nvim"
alias cp="cp -i"
alias mv="mv -i"
alias ls="ls --group-directories-first --color=auto"
alias ll="ls -lh --group-directories-first --color=auto"
alias la="ls -lah --group-directories-first --color=auto"
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias size="du -sh"
alias open='xdg-open'
alias xc='xclip -selection clipboard' # copy to clipboard using xclip
alias ytdlbest='youtube-dl -f bestvideo+bestaudio'
alias subs='subliminal download -l es -s'
alias presentation-toggle='xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -T'
alias monitor-mic='pactl load-module module-loopback latency_msec=1'
alias monitor-stop='pactl unload-module module-loopback'

# Aliases for taking notes
alias notes="cd ~/Documents/notes && nvim ."
alias draft="nvim ~/tmp/draft.md"
alias wiki="cd ~/Documents/notes/vimwiki && nvim index.md"

# Define aliases for tmux
alias ta="tmux attach -t"
alias tls="tmux list-sessions"
alias tns="tmux new-session -s"

# Run commands in background using tmux
alias lab='tmux new-session -d -s lab; tmux send-keys -t lab "cd $HOME; cenv; jupyter-lab" Enter'
alias remotelab-tera37='tmux new-session -d -s remotelab-tera37; tmux send-keys -t remotelab-tera37 "ssh -N -L 8837:localhost:8888 tera37.eos.ubc.ca" Enter'
alias remotelab-tera38='tmux new-session -d -s remotelab-tera38; tmux send-keys -t remotelab-tera38 "ssh -N -L 8838:localhost:8888 tera38.eos.ubc.ca" Enter'
alias remotelab-tera39='tmux new-session -d -s remotelab-tera39; tmux send-keys -t remotelab-tera39 "ssh -N -L 8839:localhost:8888 tera39.eos.ubc.ca" Enter'
alias remotelab-tera40='tmux new-session -d -s remotelab-tera40; tmux send-keys -t remotelab-tera40 "ssh -N -L 8840:localhost:8888 tera40.eos.ubc.ca" Enter'
alias remotelab-pytorch='tmux new-session -d -s remotelab-pytorch; tmux send-keys -t remotelab-pytorch "ssh -N -L 8899:localhost:8888 pytorch.eos.ubc.ca" Enter'
alias serve='tmux new-session -d -s serve; tmux send-keys -t serve "livereload -p 8989 ." Enter'

# Mamba aliases
alias ca='mamba activate'
alias nbx='jupyter-nbconvert --execute --to notebook --inplace --allow-errors --ExecutePreprocessor.kernel_name=python3'

# Git aliases
alias gti="git"
alias gi="git"
alias gts="git status"
alias "git-branches"="git branch -v --sort=committerdate"
alias cdtop='cd $(git rev-parse --show-toplevel)' # cd to toplevel of git repo

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Aliases for flatpak apps
if [ ! -x "$(which zola)" ]
    then
    alias zola="flatpak run org.getzola.zola"
fi


# ------
# Colors
# ------
autoload -U compinit colors zcalc
compinit -d
colors

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-R


# -------
# Plugins
# -------
#
plugins="$HOME/.zsh/plugins"

# Use syntax highlighting
if [[ -r ${plugins}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ${plugins}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Use history substring search
if [[ -r ${plugins}/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source ${plugins}/zsh-history-substring-search/zsh-history-substring-search.zsh
    # bind UP and DOWN arrow keys to history substring search
    zmodload zsh/terminfo
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    # Use jk in vim mode
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
fi


# --------------
# Terminal title
# --------------
if [[ -r ~/.zsh/terminal-title.zsh ]]; then
    source ~/.zsh/terminal-title.zsh
fi


# -----------
# zsh vi mode
# -----------
# Download plugin
plugin_dir="$plugins/zsh-vi-mode"
plugin_version="v0.9.0"
plugin_repo="https://github.com/jeffreytse/zsh-vi-mode.git"
if [[ ! -d $plugin_dir ]]; then
    git clone \
        --depth=1 \
        --branch $plugin_version \
        $plugin_repo \
        $plugin_dir
fi

# Source the zsh-vi-mode.zsh file
source "${plugin_dir}/zsh-vi-mode.zsh"

# Configure highlight colors
ZVM_VI_HIGHLIGHT_FOREGROUND=white
ZVM_VI_HIGHLIGHT_BACKGROUND=black
ZVM_VI_HIGHLIGHT_EXTRASTYLE=bold
# Disable the cursor style feature
ZVM_CURSOR_STYLE_ENABLED=false


# ----------------
# Spaceship Prompt
# ----------------
# The configuration file for spaceship is located in ~/.spaceshiprc.zsh

plugin_dir="$plugins/spaceship-vi-mode"
plugin_version="v1.0.2"
plugin_repo="https://github.com/spaceship-prompt/spaceship-vi-mode"
if [[ ! -d $plugin_dir ]]; then
    git clone \
        --depth=1 \
        --branch $plugin_version \
        $plugin_repo \
        $plugin_dir
fi

# Source the plugin file
source "${plugin_dir}/spaceship-vi-mode.plugin.zsh"

plugin_dir="$plugins/spaceship-prompt"
plugin_version="v4.12.0"
plugin_repo="https://github.com/spaceship-prompt/spaceship-prompt.git"
if [[ ! -d $plugin_dir ]]; then
    git clone \
        --depth=1 \
        --branch $plugin_version \
        $plugin_repo \
        $plugin_dir
fi

# Source the spaceship.zsh file
source "${plugin_dir}/spaceship.zsh"

# Override indicators
SPACESHIP_VI_MODE_INSERT=""
SPACESHIP_VI_MODE_NORMAL="%F{red}[N]"

# Enable vi_mode
spaceship_vi_mode_enable


# --------------
# Load functions
# --------------
if [[ -r ~/.zsh/functions.zsh ]]; then
    source ~/.zsh/functions.zsh
fi


# -----------------------
# Add directories to PATH
# -----------------------
# Add ~/bin to PATH
if [[ -d "$HOME/bin" ]]; then
    export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Add cargo bin to PATH
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi


# ------------
# Set up mamba
# ------------
if [[ -d $HOME/.mambaforge ]]; then

    # Define path for Mambaforge
    export MAMBA_PATH=$HOME/.mambaforge

    # Setup and activate the conda and mamba package managers
    __conda_setup="$('${MAMBA_PATH}/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$MAMBA_PATH/etc/profile.d/conda.sh" ]; then
            . "$MAMBA_PATH/etc/profile.d/conda.sh"
        else
            export PATH="$MAMBA_PATH/bin:$PATH"
        fi
    fi
    unset __conda_setup

    if [ -f "$MAMBA_PATH/etc/profile.d/mamba.sh" ]; then
        . "$MAMBA_PATH/etc/profile.d/mamba.sh"
    fi

    # Activate the conda default environment
    if [ -f $HOME/environment.yml ]; then
        cenv $HOME/environment.yml
    fi

fi
