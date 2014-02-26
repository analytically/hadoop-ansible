#!/bin/bash

IFS=$','

export ANSIBLE_ERROR_ON_UNDEFINED_VARS=True
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_SSH_ARGS="-o ForwardAgent=yes"

if [ ! -f "hosts" ]; then
    echo "Please create a hosts inventory file (see hosts.sample)."
    exit
fi

if [ ! -f "group_vars/all" ]; then
    echo "Please create a group_vars/all file (see group_vars/all.sample)."
    exit
fi



if [ $# -gt 0 ]
then
  echo 'Running ansible-playbook -i hosts site.yml --tags' "$*"
  ansible-playbook -i hosts --extra-vars "accelerate=true" site.yml --tags "$*"
else
  echo 'Running ansible-playbook -i hosts site.yml'
  ansible-playbook -i hosts --extra-vars "accelerate=true" site.yml
fi
