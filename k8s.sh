#!/usr/bin/env bash
set -euo pipefail


sessionName="k8s"

# check if tmux session exists
tmux ls | while read line
do
  session=$(echo $line | awk -F: '{print $1}')
  if [[ $session == $sessionName ]]
  then
    tmux kill-session -t $sessionName
  fi
done

# create new session
tmux new-session -d -s $sessionName

# create new window 
tmux new-window -t $sessionName:1 -n kubernetes
# split window vertically 
tmux split-window -t $sessionName:1.0 -v
# split window horizontally 
tmux split-window -t $sessionName:1.0 -h


# run kubernetes command
tmux selectp -t $sessionName:1.1
tmux send-keys C-z "watch kubectl get namespace -A" Enter
tmux selectp -t $sessionName:1.2
tmux send-keys C-z "watch kubectl get pods" Enter

tmux selectp -t $sessionName:1.0
tmux send-keys C-z "tmux split-window" Enter
tmux selectp -t $sessionName:1.0

# close window 0
tmux kill-window -t 0

tmux attach-session -t $sessionName
