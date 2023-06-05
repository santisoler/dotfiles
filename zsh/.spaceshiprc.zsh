# Customize some options
SPACESHIP_TIME_SHOW=false
SPACESHIP_PROMPT_ASYNC=true
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_CONDA_SYMBOL=""
SPACESHIP_GIT_BRANCH_PREFIX=""
SPACESHIP_GIT_SYMBOL=""

# Set order of elements
SPACESHIP_PROMPT_ORDER=(
  # time          # Time stampts section
  # user          # Username section
  dir           # Current directory section
  # host          # Hostname section
  git           # Git section (git_branch + git_status)
  # hg            # Mercurial section (hg_branch  + hg_status)
  # package       # Package version
  # node          # Node.js section
  # ruby          # Ruby section
  # python        # Python section
  # elm           # Elm section
  # elixir        # Elixir section
  # xcode         # Xcode section
  # swift         # Swift section
  # golang        # Go section
  # php           # PHP section
  # rust          # Rust section
  # haskell       # Haskell Stack section
  # java          # Java section
  # julia         # Julia section
  # docker        # Docker section
  # aws           # Amazon Web Services section
  # gcloud        # Google Cloud Platform section
  # venv          # virtualenv section
  conda         # conda virtualenv section
  # dotnet        # .NET section
  # kubectl       # Kubectl context section
  # terraform     # Terraform workspace section
  # ibmcloud      # IBM Cloud section
  exec_time     # Execution time
  # async         # Async jobs indicator
  vi_mode       # require spaceship-vi-mode plugin
  line_sep      # Line break
  # battery       # Battery level and status
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
