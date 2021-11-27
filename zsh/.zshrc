# =================
# zsh configuration
# =================
#
# Based on Manjaro zsh configuration files
#
#

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
zstyle ':completion:*' rehash true                        # automatically find new executables in path

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache


# -----------
# Keybindings
# -----------
bindkey -e                                         # Use emacs keybindings
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
if [[ -d $HOME/Documents/notes ]]; then
    export NOTES=$HOME/Documents/notes
elif [[ -d $HOME/documents/notes ]]; then
    export NOTES=$HOME/documents/notes
fi


# -------
# Aliases
# -------
alias v="nvim"
alias notes="cd $NOTES; nvim .; cd -"
alias todo="cd $NOTES; nvim todo.md; cd -"
alias cp="cp -i"
alias mv="mv -i"
alias ls="ls --group-directories-first --color=auto"
alias ll="ls -lh --group-directories-first --color=auto"
alias la="ls -lah --group-directories-first --color=auto"
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias du="du -h -d 0"
alias open='xdg-open'
alias xc='xclip -selection clipboard' # copy to clipboard using xclip
alias ytdlbest='youtube-dl -f bestvideo+bestaudio'
alias subs='subliminal download -l es -s'
alias presentation-toggle='xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -T'
alias monitor-mic='pactl load-module module-loopback latency_msec=1'
alias monitor-stop='pactl unload-module module-loopback'

# Define aliases for tmux
alias ta="tmux attach -t"
alias tls="tmux list-sessions"
alias tns="tmux new-session -s"

# Run commands in background using tmux
alias lab='tmux new-session -d -s lab; tmux send-keys -t lab "cd $HOME; cenv; jupyter-lab --no-browser" Enter'
alias remotelab='tmux new-session -d -s remotelab; tmux send-keys -t remotelab "ssh -N -L localhost:9999:localhost:8888 santi@soler.unsj.edu.ar" Enter'
alias remotedask='tmux new-session -d -s remotedask; tmux send-keys -t remotedask "ssh -N -L localhost:9797:localhost:8787 santi@soler.unsj.edu.ar" Enter'
alias serve='tmux new-session -d -s serve; tmux send-keys -t serve "livereload -p 8989 ." Enter'
alias futurock='tmux new-session -d -s futurock; tmux send-keys -t futurock "mplayer http://cdn2.instream.audio:8007/stream" Enter'

# Mamba aliases
alias ca='mamba activate'

# Git aliases
alias gti="git"
alias gi="git"
alias gts="git status"
alias "git-branches"="git branch -v --sort=committerdate"
alias cdtop='cd $(git rev-parse --show-toplevel)' # cd to toplevel of git repo

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


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
# Enable fish style features

# Use syntax highlighting
if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Use history substring search
if [[ -r /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
    # bind UP and DOWN arrow keys to history substring search
    zmodload zsh/terminfo
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
fi

# Offer to install missing package if command is not found
if [[ -r /usr/share/zsh/functions/command-not-found.zsh ]]; then
    source /usr/share/zsh/functions/command-not-found.zsh
    export PKGFILE_PROMPT_INSTALL_MISSING=1
fi


# ------------
# Prompt theme
# ------------
if [[ -r ~/.zsh/prompt.zsh ]]; then
    source ~/.zsh/prompt.zsh
fi


# --------------
# Load functions
# --------------
if [[ -r ~/.zsh/functions.zsh ]]; then
    source ~/.zsh/functions.zsh
fi


# -----------------------
# Add directories to PATH
# -----------------------
export PATH=$HOME/bin/:$PATH
export PATH="$PATH:$(ruby -e 'print Gem.user_dir' 2> /dev/null)/bin"

#
# ------------
# Set up mamba
# ------------
if [[ -d $HOME/.mambaforge ]]; then
    export MAMBA_PATH=$HOME/.mambaforge
fi

# Setup and activate the conda and mamaba package managerers
if [ -f $MAMBA_PATH/etc/profile.d/conda.sh ]; then
    source "$MAMBA_PATH/etc/profile.d/conda.sh"
    conda activate
fi
if [ -f "$MAMBA_PATH/etc/profile.d/mamba.sh" ]; then
    . "$MAMBA_PATH/etc/profile.d/mamba.sh"
fi

# Activate the conda default environment
if command -v conda &> /dev/null; then
  if [ -f $HOME/environment.yml ]; then
      cenv $HOME/environment.yml
  fi
fi
