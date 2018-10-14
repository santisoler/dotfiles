# Set the prompt style to include the conda env and git repository status
#
# Based on
# https://github.com/leouieda/dotfiles/blob/7772b82dc35d8d58ff9504cded966ef518cc24ce/.bash/prompt.sh

set_prompt()
{
    # Set the PS1 configuration for the prompt

    # Default values for the appearance of the prompt.
    local main_style="\[\e[1;32;40m\]"
    local path_style="\[\e[1;37;40m\]"
    local normal_style="\[\e[0m\]"
    local git_style="\[\e[1;33;40m\]"
    local python_style="\[\e[0;31;40m\]"
    local ahead="$git_style↑"
    local behind="$git_style↓"
    local diverged="$git_style↱"

    # Basic first part of the PS1 prompt
    local host="$main_style[`whoami`@`hostname` $path_style\W$main_style]"
    PS1="$host"

    # Python env
    local conda_env=`get_conda_env`
    if [[ $conda_env != "" ]]; then
        local python_env="$python_style$conda_env"
        PS1="$PS1 $python_env"
    fi

    # Build and append the git status symbols
    if inside_git_repo; then

        local git=`get_git_branch`

        local remote_status=`get_git_remote_status`
        if [[ $remote_status == "ahead" ]]; then
            local remote="$ahead"
        elif [[ $remote_status == "behind" ]]; then
            local remote="$behind"
        elif [[ $remote_status == "diverged" ]]; then
            local remote="$diverged"
        else
            local remote=""
        fi
        if [[ -n $remote ]]; then
            git="$git $remote"
        fi

        # Append the git info to the PS1
        git="$git_style$git"
        PS1="$PS1 $git"
    fi

    # Finish off with the current directory and the end of the prompt
    local end="$main_style $ $normal_style"
    PS1="$PS1$end"
}


PROMPT_COMMAND=set_prompt


get_conda_env ()
{
    # Determine active conda env details
    local env_name=""
    if [[ ! -z $CONDA_DEFAULT_ENV ]]; then
        local env_name="`basename \"$CONDA_DEFAULT_ENV\"`"
    fi
    echo "$env_name"
}


get_git_branch()
{
    # Get the name of the current git branch
    local branch=`git branch | grep "\* *" | sed -n -e "s/\* //p"`
    if [[ -z `echo $branch | grep "\(detached from *\)"` ]]; then
        echo $branch;
    else
        # In case of detached head, get the commit hash
        echo $branch | sed -n -e "s/(detached from //p" | sed -n -e "s/)//p";
    fi
}


get_git_remote_status()
{
    # Get the status regarding the remote
    local upstream=${1:-'@{u}'}
    local local=$(git rev-parse @ 2> /dev/null)
    local remote=$(git rev-parse "$upstream" 2> /dev/null)
    local base=$(git merge-base @ "$upstream" 2> /dev/null)

    if [[ $local == $remote ]]; then
        echo "updated"
    elif [[ $local == $base ]]; then
        echo "behind"
    elif [[ $remote == $base ]]; then
        echo "ahead"
    else
        echo "diverged"
    fi
}


inside_git_repo() {
    # Test if inside a git repository. Will fail is not.
    git rev-parse --is-inside-work-tree 2> /dev/null > /dev/null
}
