# Default configurations from Manjaro XFCE
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Define default TERMINAL and EDITOR
export TERMINAL=/usr/bin/terminator
export EDITOR=/usr/bin/nvim

# Configura layout del teclado a US intl with altgr, usando caps lock como altgr
# setxkbmap -layout us -variant altgr-intl -option "lv3:caps_switch"

# Configure caps lock as an extra super key
setxkbmap -layout us -variant altgr-intl -option "caps:super"
