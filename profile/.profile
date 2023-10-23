export QT_STYLE_OVERRIDE=kvantum

# Define default TERMINAL and EDITOR
export TERMINAL=/usr/bin/terminator
export EDITOR=/usr/local/bin/nvim

# Add ~/bin to PATH
if [[ -d "$HOME/bin" ]]; then
    export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
