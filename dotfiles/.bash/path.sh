# Define PATH

export PATH=$HOME/bin/:$PATH
PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"
