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
    # Make the prompt pretty and show git branch information
    source ~/.bash/prompt.sh
fi

if [ -f ~/.bash/functions.sh ]; then
    source ~/.bash/functions.sh
fi

# Include conda in the PATH by default
condaon
