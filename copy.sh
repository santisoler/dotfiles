#!/bin/bash

# Copy dotfiles to ~
# Regular cp options can be passed when running the script.
# For example:
#   $ ./copy.sh -i               # prompt before overwrite
#   $ ./copy.sh --backup=none    # doesn't backup existing files

cp -r --backup=numbered $@ dotfiles/. -t ~
