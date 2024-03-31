dir="$HOME/.config/rofi/launchers/type-1"
theme='style-1'

cliphist list | rofi -theme ${dir}/${theme}.rasi -normal-window -dmenu | cliphist decode | wl-copy
