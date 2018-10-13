#!/bin/bash

# Copy dotfiles to ~
# Regular cp options can be passed when running the script.
# For example:
#   $ ./copy.sh -f     # force the copy
#   $ ./copy.sh -b     # backup files

cp ~/.bashrc ~/.bashrc_dotfiles_backup
cp -r $@ dotfiles/. -t ~
