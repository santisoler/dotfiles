#!/bin/bash

cp ~/.bashrc ~/.bashrc_dotfiles_backup
cp -rf dotfiles/. -t ~
