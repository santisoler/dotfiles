set -g fish_greeting  # disable greeting message
starship init fish | source

fish_vi_key_bindings


# ------------
# Enable conda
# ------------
set CONDA_DIR "$HOME/.miniforge3"

if test -d $CONDA_DIR
  if test -f "$CONDA_DIR/bin/conda"
    eval "$CONDA_DIR/bin/conda" "shell.fish" "hook" $argv | source
  else
    if test -f "$CONDA_DIR/etc/fish/conf.d/conda.fish"
        . "$CONDA_DIR/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "$CONDA_DIR/bin" $PATH
    end
  end
end

