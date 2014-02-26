#!/bin/bash

if [ ! -f "ansible_rsa.pub" ]; then
    echo "Please create a ansible_rsa.pub file with your ssh key."
    exit
fi

if [ ! -f "hosts" ]; then
    echo "Please create a hosts inventory file (see hosts.sample)."
    exit
fi

export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i hosts -k -K -u ansibler -vv bootstrap.yml 
