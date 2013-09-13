#!/bin/bash
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i hosts -k -K -u ansibler bootstrap.yml