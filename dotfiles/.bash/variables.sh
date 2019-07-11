# Define variables
# ----------------
export DICEWARE_ES="$HOME/.diceware/diceware-spanish.txt"
export GEM_HOME=$HOME/.gem
export CONDA_PREFIX=$HOME/.miniconda3


# Add directories to PATH
# -----------------------
export PATH=$HOME/bin/:$PATH
export PATH="$PATH:$(ruby -e 'print Gem.user_dir' 2> /dev/null)/bin"


# The following lines are default manjaro .bashrc lines
# -----------------------------------------------------
[[ $- != *i* ]] && return

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend
