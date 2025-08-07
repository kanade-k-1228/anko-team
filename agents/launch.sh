#!/bin/bash

SESSION=${1:-anko}

if tmux has-session -t $SESSION 2>/dev/null; then
    echo "Attach to existing session '$SESSION' ..."
    tmux attach-session -t $SESSION
    exit 0
fi

echo "Panzer vor !!!"

tmux new-session -d -s $SESSION

# | 0: Miporin (mgr)      |
# | 1: Saori | 3: Akiyama |
# | 2: Mako  | 4: Hana    |

tmux split-window -v -t $SESSION:0
tmux split-window -h -t $SESSION:0.1
tmux split-window -v -t $SESSION:0.1
tmux split-window -v -t $SESSION:0.3

tmux select-pane -t $SESSION:0.0 -T "Nisizumi Miho (MGR)"
tmux select-pane -t $SESSION:0.1 -T "Takebe Saori"
tmux select-pane -t $SESSION:0.2 -T "Reizei Mako"
tmux select-pane -t $SESSION:0.3 -T "Akiyama Yukari"
tmux select-pane -t $SESSION:0.4 -T "Igarashi Hana"

tmux set-option -t $SESSION pane-border-status top
tmux set-option -t $SESSION pane-border-format "#{pane_index}: #{pane_title}"

for pane in 0.0 0.1 0.2 0.3 0.4; do
    tmux send-keys -t $SESSION:$pane "export PATH=\"\$PATH:$(pwd)/agents/bin\"" Enter
done

tmux select-pane -t $SESSION:0.0

tmux send-keys -t $SESSION:0.0 \
    'claude --dangerously-skip-permissions "Read agents/manager.md and follow the instructions"' Enter

tmux attach-session -t $SESSION
