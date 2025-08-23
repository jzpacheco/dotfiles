#!/usr/bin/env bash

if [[ -z "$2" ]]; then
    echo "Error: Should inform project's directory"
    exit 1
fi

PROJECT_PATH="$HOME/$1/$2"
if [[ ! -d "$PROJECT_PATH" ]]; then
    echo "$2 isn't a child project of $1"
    exit 1
fi

SESSION_NAME="$2"

if [[ -n "$TMUX" ]]; then
    CURRENT_SESSION=$(tmux display-message -p '#S')
    if [[ "$CURRENT_SESSION" = "$SESSION_NAME" ]]; then
        echo "This is the current session!! $CURRENT_SESSION"
        exit 0
    fi
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        tmux switch-client -t "$SESSION_NAME"
    fi
fi

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux attach -t "$SESSION_NAME"
    exit 0
fi

tmux new-session -A -d -c "$PROJECT_PATH" -s "$SESSION_NAME" -n "nvim" 2>/dev/null

# Run nvim in the main pane
tmux send-keys -t "$SESSION_NAME":1 "nvim" C-m

# Open split pane
tmux new-window -ad -t "$SESSION_NAME" -c "$PROJECT_PATH" -n "shell"

PYENV_DIR=$(find "$PROJECT_PATH" -maxdepth 1 -type d -regex ".*/\.?v?env?" | head -n1)
if [[ -d "$PYENV_DIR" ]]; then
    tmux send-keys -t "$SESSION_NAME":"shell" "source $PYENV_DIR/bin/activate" C-m
    tmux send-keys -t "$SESSION_NAME":"shell" "clear" C-m
fi

# Attach to the session
if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$SESSION_NAME"
else
    tmux attach -t "$SESSION_NAME"
fi
