#!/bin/bash

read_log () {
  counter=0
  input="ansible.log"
  while IFS= read -r line
  do
    counter=$((counter+1))
    if [[ $line =~ "======================================================" ]]; then
      echo "found it on line $counter"
      break
    fi
  done < "$input"
  counter_found=$counter
  counter=0
  while IFS= read -r line
  do
    counter=$((counter+1))
    if [[ "$((counter_found-1))" == "$counter" ]]; then
      time_line=${line: -18}
      time_line=${time_line::-6}
      echo "$time_line" >> times_$1.log
      break
    fi
  done < "$input"
}

run_playbook () {
  for i in {1..50}; do
    rm -rf ansible.log
    ansible-playbook $1 --diff
    read_log $1
  done
}

rm -rf times_*.log

run_playbook playbook_direct.yml
run_playbook playbook_jumphost.yml
run_playbook playbook_warpgate.yml
