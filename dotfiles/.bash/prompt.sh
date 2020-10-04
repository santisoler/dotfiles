# Set the prompt style to include the conda env and git repository status
#
# Based on
# https://github.com/leouieda/dotfiles/blob/7772b82dc35d8d58ff9504cded966ef518cc24ce/.bash/prompt.sh


# Define font colors
white="\[\e[0m\]"
red="\[\e[0;31m\]"
green="\[\e[0;32m\]"
yellow="\[\e[0;33m\]"
blue="\[\e[0;34m\]"
purple="\[\e[0;35m\]"
light_blue="\[\e[0;36m\]"

white_bold="\[\e[0m\e[1m\]"
red_bold="\[\e[1;31m\]"
green_bold="\[\e[1;32m\]"
yellow_bold="\[\e[1;33m\]"
blue_bold="\[\e[1;34m\]"
purple_bold="\[\e[1;35m\]"
light_blue_bold="\[\e[1;36m\]"

# Define styles for git and conda information on prompt
CONDA_PROMPT_ENV="$purple_bold "
GIT_PROMPT_BRANCH="$yellow_bold "
GIT_PROMPT_AHEAD="$yellow_bold↑"
GIT_PROMPT_BEHIND="$yellow_bold↓"
GIT_PROMPT_NOUPSTREAM="$yellow_bold!"
GIT_PROMPT_DIVERGED="$red_bold↱"
GIT_PROMPT_CHANGED="$red_bold+"
GIT_PROMPT_STAGED="$green_bold•"
GIT_PROMPT_UNTRACKED="$white_bold|"
GIT_PROMPT_CONFLICT="$red_bold✖"
GIT_PROMPT_STASHED="$purple_bold✹"

# More configurations
MULTILINE_PROMPT=1
PROMPT_DIRTRIM=2  # make path shorter
PROMPT_ICON="⮞"
# PROMPT_ICON="❯"


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
    local user="$green_bold$USER"
    local host="$green_bold`hostname`"
    local path="$blue_bold\w"
    local at_="${white}at"
    local on_="${white}on"
    local in_="${white}in"
    local with_="${white}with"
    PS1+="$user $at_ $host $in_ $path"


    # Add git prompt (branch and remote status)
    if inside_git_repo; then
        PS1+=" $on_ `get_git_prompt`"
    fi

    # Conda env
    if [[ `which python` != "/usr/bin/python" ]]; then
        PS1+=" $with_ $CONDA_PROMPT_ENV`get_conda_env`"
    fi

    # Add git status
    if inside_git_repo; then
        local git_status=$(get_git_status)
        if [[ $git_status != "" ]]; then
            PS1+=" $white[`get_git_status`$white]"
        fi
    fi

    # Enable multiline
    if [[ $MULTILINE_PROMPT -ne 0 ]]; then
        PS1+="\n"
    else
        PS1+=" "
    fi

    # Add number of background jobs to prompt
    if [[ $njobs -ne 0 ]]; then
        PS1+="$red_bold($njobs) "
    fi

    # Add prompt symbol (color is set based on last exit code)
    local prompt_symbol=""
    if [ $EXIT == 0 ]; then
        prompt_symbol+="$green_bold"
    else
        prompt_symbol+="$red_bold"
    fi
    prompt_symbol+="$PROMPT_ICON "
    PS1+="$prompt_symbol"

    # Reset color of prompt
    PS1+="$white"
}


PROMPT_COMMAND=set_prompt

get_git_prompt() {
    # Return current git branch and remote status

    # Initialize git_prompt local variable
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

    echo $git_prompt
}

get_git_status() {
    # Return git current status

    # Files status
    local git_status=""

    local files_staged=`git diff --cached --numstat | wc -l`
    if [[ $files_staged -ne 0 ]]; then
        git_status+="$GIT_PROMPT_STAGED$files_staged"
    fi

    local files_changed=`git diff --numstat | wc -l`
    if [[ $files_changed -ne 0 ]]; then
        git_status+="$GIT_PROMPT_CHANGED$files_changed"
    fi

    local files_untracked=`git ls-files --others --exclude-standard "$(git rev-parse --show-toplevel)" | wc -l`
    if [[ $files_untracked -ne 0 ]]; then
        git_status+="$GIT_PROMPT_UNTRACKED$files_untracked"
    fi

    local files_conflict=`git diff --name-only --diff-filter=U | wc -l`
    if [[ $files_conflict -ne 0 ]]; then
        git_status+="$GIT_PROMPT_CONFLICT$files_conflict"
    fi

    local files_stashed=`git stash list | wc -l`
    if [[ $files_stashed -ne 0 ]]; then
        git_status+="$GIT_PROMPT_STASHED$files_stashed"
    fi

    echo $git_status
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
