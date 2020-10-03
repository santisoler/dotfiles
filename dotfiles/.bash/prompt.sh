# Set the prompt style to include the conda env and git repository status
#
# Based on
# https://github.com/leouieda/dotfiles/blob/7772b82dc35d8d58ff9504cded966ef518cc24ce/.bash/prompt.sh


# Make path shorter
PROMPT_DIRTRIM=2

# Define font colors
export WHITE="\e[0m"
export RED="\e[31m"
export GREEN="\e[32m"
export YELLOW="\e[33m"
export BLUE="\e[34m"
export PURPLE="\e[35m"
export LIGHT_BLUE="\e[36m"

export WHITE_BOLD="\e[0m\e[1m"
export RED_BOLD="\e[1;31m"
export GREEN_BOLD="\e[1;32m"
export YELLOW_BOLD="\e[1;33m"
export BLUE_BOLD="\e[1;34m"
export PURPLE_BOLD="\e[1;35m"
export LIGHT_BLUE_BOLD="\e[1;36m"


# Define styles for git and conda information on prompt
export CONDA_PROMPT_ENV=$PURPLE_BOLD
export GIT_PROMPT_BRANCH=$YELLOW_BOLD
export GIT_PROMPT_AHEAD="$YELLOW_BOLD↑"
export GIT_PROMPT_BEHIND="$YELLOW_BOLD↓"
export GIT_PROMPT_NOUPSTREAM="$YELLOW_BOLD!"
export GIT_PROMPT_DIVERGED="$RED_BOLD↱"
export GIT_PROMPT_CHANGED="$RED_BOLD+"
export GIT_PROMPT_STAGED="$GREEN_BOLD•"
export GIT_PROMPT_UNTRACKED="$WHITE_BOLD|"
export GIT_PROMPT_CONFLICT="$RED_BOLD✖"
export GIT_PROMPT_STASHED="$PULRPLE_BOLD✹"


set_prompt()
{
    # Set the PS1 configuration for the prompt

    # Capture last exit code
    local EXIT="$?"

    # Capture background jobs
    local njobs=`jobs | wc -l`

    # Initialize PS1
    PS1=""

    # Add a linebreak before prompt
    PS1+="\n"

    # Basic first part of the PS1 prompt
    local user="$GREEN_BOLD$USER"
    local host="$GREEN_BOLD`hostname`"
    local path="$WHITE_BOLD\w"
    local at_="${WHITE}at"
    local on_="${WHITE}on"
    local in_="${WHITE}in"
    PS1+="$user $at_ $host $in_ $path"


    # Conda env
    if [[ `which python` != "/usr/bin/python" ]]; then
        PS1+=" $CONDA_PROMPT_ENV`get_conda_env`"
    fi

    # Add git information
    if inside_git_repo; then
        PS1+=" `get_git_prompt`"
    fi

    # Enable multiline
    PS1+="\n"

    # Add number of background jobs to prompt
    if [[ $njobs -ne 0 ]]; then
        PS1+="$WHITE($njobs) "
    fi

    # Add prompt symbol (color is set based on last exit code)
    local prompt_symbol=""
    if [ $EXIT == 0 ]; then
        prompt_symbol+="$GREEN_BOLD"
    else
        prompt_symbol+="$RED_BOLD"
    fi
    prompt_symbol+="> "
    PS1+="$prompt_symbol"

    # Reset color of prompt
    PS1+="$WHITE"
}


PROMPT_COMMAND=set_prompt

get_git_prompt() {
    # Add git repo information to prompt

    # Initialize git prompt
    local git_prompt=""

    # Add branch
    local branch=`get_git_branch`
    git_prompt+="$GIT_PROMPT_BRANCH$branch"

    # Remote status
    local remote_status=`get_git_remote_status`
    if [[ $remote_status == "ahead" ]]; then
        local remote="$GIT_PROMPT_AHEAD"
    elif [[ $remote_status == "behind" ]]; then
        local remote="$GIT_PROMPT_BEHIND"
    elif [[ $remote_status == "noupstream" ]]; then
        local remote="$GIT_PROMPT_NOUPSTREAM"
    elif [[ $remote_status == "diverged" ]]; then
        local remote="$GIT_PROMPT_DIVERGED"
    else
        local remote=""
    fi

    if [[ -n $remote ]]; then
        git_prompt+=" $remote"
    fi

    # Files status
    local files_status=""

    local files_staged=`git diff --cached --numstat | wc -l`
    if [[ $files_staged -ne 0 ]]; then
        files_status+="$GIT_PROMPT_STAGED$files_staged"
    fi

    local files_changed=`git diff --numstat | wc -l`
    if [[ $files_changed -ne 0 ]]; then
        files_status+="$GIT_PROMPT_CHANGED$files_changed"
    fi

    local files_untracked=`git ls-files --others --exclude-standard "$(git rev-parse --show-toplevel)" | wc -l`
    if [[ $files_untracked -ne 0 ]]; then
        files_status+="$GIT_PROMPT_UNTRACKED$files_untracked"
    fi

    local files_conflict=`git diff --name-only --diff-filter=U | wc -l`
    if [[ $files_conflict -ne 0 ]]; then
        files_status+="$GIT_PROMPT_CONFLICT$files_conflict"
    fi

    local files_stashed=`git stash list | wc -l`
    if [[ $files_stashed -ne 0 ]]; then
        files_status+="$GIT_PROMPT_STASHED$files_stashed"
    fi

    if [[ -n $files_status ]]; then
        git_prompt+=" $files_status"
    fi

    echo $git_prompt
}


get_conda_env()
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
    local has_remote=$(git rev-parse --remotes | wc -l)
    local upstream=${1:-'@{u}'}
    local local=$(git rev-parse @ 2> /dev/null)
    local remote=$(git rev-parse "$upstream" 2> /dev/null)
    local has_upstream=$(git rev-parse "$upstream" 2> /dev/null | wc -l)
    local base=$(git merge-base @ "$upstream" 2> /dev/null)

    if [[ $has_remote -eq 0 ]]; then
        echo "noremote"
    elif [[ $has_upstream -eq 0 ]]; then
        echo "noupstream"
    elif [[ $local == $remote ]]; then
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
