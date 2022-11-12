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
      echo "$line" >> times_$1.log
      break
    fi
  done < "$input"
}

run_playbook () {
  for i in {1..10}; do
    rm -rf ansible.log
    ansible-playbook $1 --diff
    read_log $1
  done
}

run_playbook playbook_direct.yml
run_playbook playbook_jumphost.yml
run_playbook playbook_warpgate.yml
