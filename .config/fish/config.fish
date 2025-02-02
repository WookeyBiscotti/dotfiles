if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x GTK_THEME "Adwaita:dark"
set -x LANG ru_RU.UTF-8
set -x LC_CTYPE ru_RU.UTF-8
fish_add_path /opt/clang-format-static

set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

set GDK_BACKEND wayland

# Add pyenv executable to PATH by running
# the following interactively:

set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

# Load pyenv automatically by appending
# the following to ~/.config/fish/config.fish:

pyenv init - | source
