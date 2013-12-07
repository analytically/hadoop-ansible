#!/bin/sh

echo 'installing Dopy'
sudo pip install dopy

echo 'install the Travis CI SSH key'
ssh-add travis.ssh

echo 'running ansible-playbook after_success_setup.yml'
ansible-playbook -i after_success_hosts --extra-vars "api_key=$DO_API_KEY client_id=$DO_CLIENT_ID" after_success_setup.yml

./site.sh

echo 'running ansible-playbook after_success_teardown.yml'
ansible-playbook -i after_success_hosts --extra-vars "api_key=$DO_API_KEY client_id=$DO_CLIENT_ID" after_success_teardown.yml