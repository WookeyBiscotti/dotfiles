hyprctl devices | grep -A 3 "8bitdo-8bitdo-retro-keyboard-1" | grep "active keymap:" | tail -n 1 | awk '{print tolower(substr($3,1,2))}'
