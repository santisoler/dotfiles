#
# ~/.bashrc
#
if [ -f ~/.bash/variables.sh ]; then
    source ~/.bash/variables.sh
fi

if [ -f ~/.bash/aliases.sh ]; then
    source ~/.bash/aliases.sh
fi

if [ -f ~/.bash/colors.sh ]; then
    source ~/.bash/colors.sh
fi

if [ -f ~/.bash/prompt.sh ]; then
    # Source Tilix script for configuring VTE
    # We are using the __vte_osc7 function on our set_prompt function in .bash/prompt.sh
    if [[ $TILIX_ID ]]; then
        source /etc/profile.d/vte.sh
    fi
    # Make the prompt pretty and show git branch information
    source ~/.bash/prompt.sh
fi

if [ -f ~/.bash/functions.sh ]; then
    source ~/.bash/functions.sh
fi

# Setup and activate the conda package manager
if [ -f $CONDA_PREFIX/etc/profile.d/conda.sh ]; then
    source "$CONDA_PREFIX/etc/profile.d/conda.sh"
    conda activate
fi

# Activate my default environment to keep the base env clean
cenv $HOME/environment.yml
