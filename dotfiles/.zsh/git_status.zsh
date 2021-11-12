#
# Git status
#
# Modified version of the git_status section of spaceship-prompt, which is made
# available under the MIT License by Denys Dovhan.
# Source code: https://github.com/spaceship-prompt/spaceship-prompt
#
# This modified version prints the number of files that falls under each git
# category (added, untracked, modified, renamed, stashed, etc) and sets each
# category with a color.

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_GIT_STATUS_SHOW="true"
SPACESHIP_GIT_STATUS_PREFIX=" %{$fg[white]%}["
SPACESHIP_GIT_STATUS_SUFFIX="%{$fg[white]%}]"
SPACESHIP_GIT_STATUS_COLOR="red"
SPACESHIP_GIT_STATUS_UNTRACKED="%{$fg[white]%}|"
SPACESHIP_GIT_STATUS_ADDED="%{$fg[green]%}+"
SPACESHIP_GIT_STATUS_MODIFIED="%{$fg[red]%}!"
SPACESHIP_GIT_STATUS_RENAMED="%{$fg[red]%}»"
SPACESHIP_GIT_STATUS_DELETED="%{$fg[red]%}✘"
SPACESHIP_GIT_STATUS_STASHED="%{$fg[magenta]%}$"
SPACESHIP_GIT_STATUS_UNMERGED="${SPACESHIP_GIT_STATUS_UNMERGED="="}"
SPACESHIP_GIT_STATUS_AHEAD="${SPACESHIP_GIT_STATUS_AHEAD="⇡"}"
SPACESHIP_GIT_STATUS_BEHIND="${SPACESHIP_GIT_STATUS_BEHIND="⇣"}"
SPACESHIP_GIT_STATUS_DIVERGED="${SPACESHIP_GIT_STATUS_DIVERGED="⇕"}"

spaceship_git_status() {
  [[ $SPACESHIP_GIT_STATUS_SHOW == false ]] && return

  spaceship::is_git || return

  local INDEX git_status count=""

  INDEX=$(command git status --porcelain -b 2> /dev/null)

  # Check whether branch is ahead
  local is_ahead=false
  if $(echo "$INDEX" | command grep '^## [^ ]\+ .*ahead' &> /dev/null); then
    is_ahead=true
  fi

  # Check whether branch is behind
  local is_behind=false
  if $(echo "$INDEX" | command grep '^## [^ ]\+ .*behind' &> /dev/null); then
    is_behind=true
  fi

  # Check wheather branch has diverged
  if [[ "$is_ahead" == true && "$is_behind" == true ]]; then
    git_status+="$SPACESHIP_GIT_STATUS_DIVERGED"
  else
    [[ "$is_ahead" == true ]] && git_status+="$SPACESHIP_GIT_STATUS_AHEAD"
    [[ "$is_behind" == true ]] && git_status+="$SPACESHIP_GIT_STATUS_BEHIND"
  fi


  # Check for staged files
  if $(echo "$INDEX" | command grep '^A[ MDAU] ' &> /dev/null); then
    count=$(echo "$INDEX" | command grep -E '^A[ MDAU] ' | wc -l)
    git_status+="$SPACESHIP_GIT_STATUS_ADDED$count"
  elif $(echo "$INDEX" | command grep '^M[ MD] ' &> /dev/null); then
    count=$(echo "$INDEX" | command grep -E '^M[ MD] ' | wc -l)
    git_status+="$SPACESHIP_GIT_STATUS_ADDED$count"
  elif $(echo "$INDEX" | command grep '^UA' &> /dev/null); then
    count=$(echo "$INDEX" | command grep -E '^UA' | wc -l)
    git_status+="$SPACESHIP_GIT_STATUS_ADDED$count"
  fi

  # Check for modified files
  if $(echo "$INDEX" | command grep '^[ MARC]M ' &> /dev/null); then
    count=$(echo "$INDEX" | command grep -E '^[ MARC]M ' | wc -l)
    git_status+="$SPACESHIP_GIT_STATUS_MODIFIED$count"
  fi

  # Check for renamed files
  if $(echo "$INDEX" | command grep '^R[ MD] ' &> /dev/null); then
    count=$(echo "$INDEX" | command grep -E '^R[ MD] ' | wc -l)
    git_status+="$SPACESHIP_GIT_STATUS_RENAMED$count"
  fi

  # Check for deleted files
  if $(echo "$INDEX" | command grep '^[MARCDU ]D ' &> /dev/null); then
    count=$(echo "$INDEX" | command grep -E '^[MARCDU ]D ' | wc -l)
    git_status+="$SPACESHIP_GIT_STATUS_DELETED$count"
  elif $(echo "$INDEX" | command grep '^D[ UM] ' &> /dev/null); then
    count=$(echo "$INDEX" | command grep -E '^D[ UM] ' | wc -l)
    git_status+="$SPACESHIP_GIT_STATUS_DELETED$count"
  fi

  # Check for untracked files
  if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
    count=$(echo "$INDEX" | command grep -E '^\?\? ' | wc -l)
    git_status+="$SPACESHIP_GIT_STATUS_UNTRACKED$count"
  fi

  # Check for unmerged files
  if $(echo "$INDEX" | command grep '^U[UDA] ' &> /dev/null); then
    count=$(echo "$INDEX" | command grep -E '^U[UDA] ' | wc -l)
    git_status+="$SPACESHIP_GIT_STATUS_UNMERGED$count"
  elif $(echo "$INDEX" | command grep '^AA ' &> /dev/null); then
    count=$(echo "$INDEX" | command grep -E '^AA ' | wc -l)
    git_status+="$SPACESHIP_GIT_STATUS_UNMERGED$count"
  elif $(echo "$INDEX" | command grep '^DD ' &> /dev/null); then
    count=$(echo "$INDEX" | command grep -E '^DD ' | wc -l)
    git_status+="$SPACESHIP_GIT_STATUS_UNMERGED$count"
  elif $(echo "$INDEX" | command grep '^[DA]U ' &> /dev/null); then
    count=$(echo "$INDEX" | command grep -E '^[DA]U ' | wc -l)
    git_status+="$SPACESHIP_GIT_STATUS_UNMERGED$count"
  fi

  # Check for stashes
  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    git_status+="$SPACESHIP_GIT_STATUS_STASHED"
  fi

  if [[ -n $git_status ]]; then
    # Status prefixes are colorized
    spaceship::section \
      "$SPACESHIP_GIT_STATUS_COLOR" \
      "$SPACESHIP_GIT_STATUS_PREFIX$git_status$SPACESHIP_GIT_STATUS_SUFFIX"
  fi
}

