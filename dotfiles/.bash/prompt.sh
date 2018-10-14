# Set the prompt style to include the conda env and git repository status
#
# Started out as an apdaptation of https://github.com/magicmonty/bash-git-prompt
# but I ended up completely re-implementing everything using only bash.
# The result is faster and probably won't break between Python versions.


set_prompt()
{
    # Set the PS1 configuration for the prompt

    # Default values for the appearance of the prompt.
    local main_style="\[\e[1;32m\]"
    local path_style="\[\e[1;37m\]"
    local normal_style="\[\e[0m\]"
    local gitbranch_style="\[\e[1;33m\]"
    #local changed="\[\033[01;32m\]✚"
    #local staged="\[\033[01;32m\]●"
    #local untracked="$main_style…"
    #local conflict="\[\033[01;32m\]✖"
    #local ahead="$main_style↑"
    #local behind="$main_style↓"
    #local diverged="$main_style⑂"

    # Basic first part of the PS1 prompt
    #local host="\[\e[0;97;100m\] `whoami`@`hostname` "
    local host="$main_style[`whoami`@`hostname` $path_style\W$main_style]"
    #local python_env="\[\033[01;37m\] `get_conda_env`\[\033[01;32m\]]"

    #PS1="$host$python_env"
    PS1="$host"

    # Build and append the git status symbols
    if inside_git_repo; then
        # Construct the status info (how many files changed, etc)
        local status=""

        #local files_changed=`git diff --numstat | wc -l`
        #if [[ $files_changed -ne 0 ]]; then
            #local status="$status $changed $files_changed"
        #fi

        #local files_staged=`git diff --cached --numstat | wc -l`
        #if [[ $files_staged -ne 0 ]]; then
            #local status="$status $staged $files_staged"
        #fi

        #local files_conflict=`git diff --name-only --diff-filter=U | wc -l`
        #if [[ $files_conflict -ne 0 ]]; then
            #local status="$status $conflict $files_conflict"
        #fi

        #local files_untracked=`git ls-files --others --exclude-standard | wc -l`
        #if [[ $files_untracked -ne 0 ]]; then
            #local status="$status $untracked$files_untracked"
        #fi

        #local remote_status=`get_git_remote_status`
        #if [[ $remote_status == "ahead" ]]; then
            #local remote="$ahead"
        #elif [[ $remote_status == "behind" ]]; then
            #local remote="$behind"
        #elif [[ $remote_status == "diverged" ]]; then
            #local remote="$diverged"
        #else
            #local remote=""
        #fi
        #if [[ -n $remote ]]; then
            #local status="$status $remote"
        #fi

        local branch=`get_git_branch`

        # Append the git info to the PS1
        local git="$gitbranch_style$branch"
        if [[ -n $status ]]; then
            local git="$git$status"
        fi
        PS1="$PS1 $git "
    fi

    # Finish off with the current directory and the end of the prompt
    #local path="\[\033[01;33m\] \W"
    #local end="$reset_color $ "
    local end="$main_style$ $normal_style"

    PS1="$PS1$end"
}


PROMPT_COMMAND=set_prompt


get_conda_env ()
{
    # Determine active conda env details
    local env_name="base"
    if [[ ! -z $CONDA_DEFAULT_ENV ]]; then
        local env_name="`basename \"$CONDA_DEFAULT_ENV\"`"
    fi
    local python_version="$(python -c 'from __future__ import print_function; import sys; print(".".join(map(str, sys.version_info[:2])))')"
    echo "$env_name-$python_version"
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
