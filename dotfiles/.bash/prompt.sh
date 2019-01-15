# Set the prompt style to include the conda env and git repository status
#
# Based on
# https://github.com/leouieda/dotfiles/blob/7772b82dc35d8d58ff9504cded966ef518cc24ce/.bash/prompt.sh


# Set PROMPT_COMMAND as set_prompt function and a line that
# changes the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='set_prompt && echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='set_prompt && echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac


set_prompt()
{
    # Set the PS1 configuration for the prompt

    # Default values for the appearance of the prompt.
    local main_style="\[\e[1;32m\]"
    local path_style="\[\e[0m\]\[\e[1m\]"
    local normal_style="\[\e[0m\]"
    local git_style="\[\e[1;33m\]"
    local python_style="\[\e[0;35m\]"
    local ahead="$git_style↑"
    local behind="$git_style↓"
    local noupstream="$git_style!"
    local diverged="\[\e[1;31m\]↱$normal_style"
    local changed="\[\e[1;31m\]✚"
    local staged="\[\e[1;32m\]•"
    local untracked="\[\e[0m\]\[\e[1m\]|"
    local conflict="\[\e[1;31m\]✖"

    # Basic first part of the PS1 prompt
    local host="$main_style[`whoami`@`hostname` $path_style\W$main_style]"
    PS1="$host"

    local njobs=`jobs | wc -l`
    if [[ $njobs -ne 0 ]]; then
        PS1="$PS1 $normal_style($njobs)"
    fi

    # Python env
    local conda_env=`get_conda_env`
    if [[ $conda_env != "" ]]; then
        PS1="$PS1 $python_style$conda_env"
    fi

    # Build and append the git status symbols
    if inside_git_repo; then

        # Branch
        local git=`get_git_branch`

        # Remote status
        local remote_status=`get_git_remote_status`
        if [[ $remote_status == "ahead" ]]; then
            local remote="$ahead"
        elif [[ $remote_status == "behind" ]]; then
            local remote="$behind"
        elif [[ $remote_status == "noupstream" ]]; then
            local remote="$noupstream"
        elif [[ $remote_status == "diverged" ]]; then
            local remote="$diverged"
        else
            local remote=""
        fi

        if [[ -n $remote ]]; then
            local git="$git $remote"
        fi

        # Files status
        local files_status=""

        local files_staged=`git diff --cached --numstat | wc -l`
        if [[ $files_staged -ne 0 ]]; then
            local files_status="$files_status$staged$files_staged"
        fi

        local files_changed=`git diff --numstat | wc -l`
        if [[ $files_changed -ne 0 ]]; then
            local files_status="$files_status$changed$files_changed"
        fi

        local files_untracked=`git ls-files --others --exclude-standard "$(git rev-parse --show-toplevel)" | wc -l`
        if [[ $files_untracked -ne 0 ]]; then
            local files_status="$files_status$untracked$files_untracked"
        fi

        local files_conflict=`git diff --name-only --diff-filter=U | wc -l`
        if [[ $files_conflict -ne 0 ]]; then
            local files_status="$files_status$conflict$files_conflict"
        fi

        if [[ -n $files_status ]]; then
            local git="$git $files_status"
        fi

        # Append the git info to the PS1
        if [[ -n $git ]]; then
            PS1="$PS1 $git_style$git"
        fi
    fi

    # Finish off with the current directory and the end of the prompt
    if [[ $conda_env == "" ]] && [[ $git == "" ]] && [[ $njobs -eq 0 ]]; then
        local end="$main_style$ $normal_style"
    else
        local end="$main_style $ $normal_style"
    fi
    PS1="$PS1$end"
}


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
