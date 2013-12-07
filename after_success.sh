#!/bin/sh

echo 'installing Dopy'
sudo pip install dopy

echo 'install the Travis CI SSH key'
chmod 400 travis.ssh
eval `ssh-agent`
ssh-add travis.ssh

touch privatehosts
echo 'running ansible-playbook after_success_setup.yml'
ansible-playbook -i after_success_hosts --extra-vars "api_key_password=$DO_API_KEY client_id=$DO_CLIENT_ID" after_success_setup.yml

export ANSIBLE_HOST_KEY_CHECKING=False

cp travis.ssh.pub bootstrap/ansible_rsa.pub
cd bootstrap
ansible-playbook -i hosts -u root bootstrap.yml
cd ..

./site.sh

echo 'running ansible-playbook after_success_teardown.yml'
ansible-playbook -i after_success_hosts --extra-vars "api_key_password=$DO_API_KEY client_id=$DO_CLIENT_ID" after_success_teardown.yml