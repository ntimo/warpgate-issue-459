#!/bin/bash

run_playbook () {
  for i in {1..50}; do
    rm -rf ansible.log
    ansible-playbook $1 --diff -vvvv
    mv ansible.log pipe_logs/$i.log
  done
}

run_playbook playbook_warpgate.yml
