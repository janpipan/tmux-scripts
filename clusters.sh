#!/usr/bin/env bash
set -euo pipefail


sessionName="clusters"

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
tmux send-keys C-z "nvim $PWD/clusters/" Enter

# create new window for each session
declare -i sessionNum=1
ls ./clusters | while read line
do
  tmux new-window -t $sessionName:$sessionNum -n $line 
  tmux select-window -t $sessionName:$sessionNum  
  tmux send-keys C-z  "nvim $PWD/clusters/$line/" Enter 
  sessionNum+=1
done


tmux attach-session -t $sessionName
