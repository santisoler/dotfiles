#!/bin/bash

# In order to runt this script at login, add the following to autostart:
# xfce4-terminal -e /path/to/ssh-add-script.sh

echo "Enter SSH password for ssh-agent"
echo "--------------------------------"
ssh-add
