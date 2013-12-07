#!/bin/sh

echo 'installing Dopy'
sudo pip install dopy

echo 'install the Travis CI SSH key'
eval `ssh-agent`
ssh-add $CI_HOME/travis.ssh

echo 'running ansible-playbook after_success_setup.yml'
ansible-playbook -i $CI_HOME/after_success_hosts --extra-vars "api_key=$DO_API_KEY client_id=$DO_CLIENT_ID" $CI_HOME/after_success_setup.yml

export ANSIBLE_HOST_KEY_CHECKING=False

mkdir bootstrap
cp $CI_HOME/bootstrap/* bootstrap
cp $CI_HOME/travis.ssh.pub bootstrap/ansible_rsa.pub
cd bootstrap
ansible-playbook -i hosts -u root bootstrap.yml

$CI_HOME/site.sh

echo 'running ansible-playbook after_success_teardown.yml'
ansible-playbook -i $CI_HOME/after_success_hosts --extra-vars "api_key=$DO_API_KEY client_id=$DO_CLIENT_ID" $CI_HOME/after_success_teardown.yml