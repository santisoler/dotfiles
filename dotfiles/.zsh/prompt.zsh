
# Set terminal window and tab/icon title
#
# usage: title short_tab_title [long_window_title]
#
# See: http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
# Fully supports screen and probably most modern xterm and rxvt
# (In screen, only short_tab_title is used)
function title {
  emulate -L zsh
  setopt prompt_subst

  [[ "$EMACS" == *term* ]] && return

  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  case "$TERM" in
    xterm*|putty*|rxvt*|konsole*|ansi|mlterm*|alacritty|st*)
      print -Pn "\e]2;${2:q}\a" # set window name
      print -Pn "\e]1;${1:q}\a" # set tab name
      ;;
    screen*|tmux*)
      print -Pn "\ek${1:q}\e\\" # set screen hardstatus
      ;;
    *)
    # Try to use terminfo to set the title
    # If the feature is available set title
    if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
      echoti tsl
      print -Pn "$1"
      echoti fsl
    fi
      ;;
  esac
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n@%m:%~"

# Runs before showing the prompt
function mzc_termsupport_precmd {
  [[ "${DISABLE_AUTO_TITLE:-}" == true ]] && return
  title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
}

# Runs before executing the command
function mzc_termsupport_preexec {
  [[ "${DISABLE_AUTO_TITLE:-}" == true ]] && return

  emulate -L zsh

  # split command into array of arguments
  local -a cmdargs
  cmdargs=("${(z)2}")
  # if running fg, extract the command from the job description
  if [[ "${cmdargs[1]}" = fg ]]; then
    # get the job id from the first argument passed to the fg command
    local job_id jobspec="${cmdargs[2]#%}"
    # logic based on jobs arguments:
    # http://zsh.sourceforge.net/Doc/Release/Jobs-_0026-Signals.html#Jobs
    # https://www.zsh.org/mla/users/2007/msg00704.html
    case "$jobspec" in
      <->) # %number argument:
        # use the same <number> passed as an argument
        job_id=${jobspec} ;;
      ""|%|+) # empty, %% or %+ argument:
        # use the current job, which appears with a + in $jobstates:
        # suspended:+:5071=suspended (tty output)
        job_id=${(k)jobstates[(r)*:+:*]} ;;
      -) # %- argument:
        # use the previous job, which appears with a - in $jobstates:
        # suspended:-:6493=suspended (signal)
        job_id=${(k)jobstates[(r)*:-:*]} ;;
      [?]*) # %?string argument:
        # use $jobtexts to match for a job whose command *contains* <string>
        job_id=${(k)jobtexts[(r)*${(Q)jobspec}*]} ;;
      *) # %string argument:
        # use $jobtexts to match for a job whose command *starts with* <string>
        job_id=${(k)jobtexts[(r)${(Q)jobspec}*]} ;;
    esac

    # override preexec function arguments with job command
    if [[ -n "${jobtexts[$job_id]}" ]]; then
      1="${jobtexts[$job_id]}"
      2="${jobtexts[$job_id]}"
    fi
  fi

  # cmd name only, or if this is sudo or ssh, the next cmd
  local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
  local LINE="${2:gs/%/%%}"

  title '$CMD' '%100>...>$LINE%<<'
}

autoload -U add-zsh-hook
add-zsh-hook precmd mzc_termsupport_precmd
add-zsh-hook preexec mzc_termsupport_preexec



# Spaceship Prompt
# ----------------
autoload -U promptinit; promptinit
prompt spaceship


# Write own git_status function with numbers of files and colors
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


SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  # hg            # Mercurial section (hg_branch  + hg_status)
  package       # Package version
  # gradle        # Gradle section
  # maven         # Maven section
  # node          # Node.js section
  # ruby          # Ruby section
  # elixir        # Elixir section
  # xcode         # Xcode section
  # swift        # Swift section
  # golang        # Go section
  # php           # PHP section
  # rust          # Rust section
  # haskell       # Haskell Stack section
  # julia         # Julia section
  # docker        # Docker section
  # aws           # Amazon Web Services section
  # gcloud        # Google Cloud Platform section
  # venv          # virtualenv section
  conda         # conda virtualenv section
  pyenv         # Pyenv section
  # dotnet        # .NET section
  # ember         # Ember.js section
  # kubectl       # Kubectl context section
  # terraform     # Terraform workspace section
  # exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_USER_SHOW=always
SPACESHIP_HOST_SHOW=always
SPACESHIP_CONDA_SYMBOL=" "

