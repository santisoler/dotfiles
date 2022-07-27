#!/bin/bash

# Rename home folders to lowercase names

folders="Documents Downloads Music Pictures Public Templates Videos"

for folder in $folders; do
    lowercase_name=$(echo "$folder" | tr '[:upper:]' '[:lower:]')
    # Rename each folder
    mv "$folder" "$lowercase_name"
    # Change folder name in ~/.config/users-dirs.dirs
    sed -i 's/'${folder}'/'${lowercase_name}'/' "$HOME/.config/user-dirs.dirs"
done

# Update XDG users dirs
xdg-user-dirs-update
