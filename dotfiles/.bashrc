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

# Initialize conda
__conda_setup="$('$CONDA_PREFIX/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA_PREFIX/etc/profile.d/conda.sh" ]; then
        . "$CONDA_PREFIX/etc/profile.d/conda.sh"
    else
        export PATH="$CONDA_PREFIX/bin:$PATH"
    fi
fi
unset __conda_setup

# Initialize ssh agent
if [ -f ~/.ssh/agent.env ] ; then
    . ~/.ssh/agent.env > /dev/null
    if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
        # echo "Stale agent file found. Spawning new agent… "
        eval `ssh-agent | tee ~/.ssh/agent.env`
        # ssh-add
    fi
else
    # echo "Starting ssh-agent"
    eval `ssh-agent | tee ~/.ssh/agent.env`
    # ssh-add
fi

# Activate the conda default environment
if [ -f $HOME/environment.yml ]; then
    cenv $HOME/environment.yml
fi


