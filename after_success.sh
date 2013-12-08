#!/bin/sh

export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_SSH_ARGS="-o ForwardAgent=yes"

sudo pip install dopy

echo 'Install the Travis CI SSH key'
chmod 400 travis.ssh
eval `ssh-agent`
ssh-add travis.ssh

echo 'Touch local temp files'
touch privatehosts
sudo touch /etc/rc6.d/K10do_destroy.sh
sudo chmod +x /etc/rc6.d/K10do_destroy.sh

echo 'Run ansible-playbook after_success.yml'
ansible-playbook -i after_success_hosts --extra-vars "api_key_password=$DO_API_KEY client_id=$DO_CLIENT_ID" after_success.yml

sleep 10

cp travis.ssh.pub bootstrap/ansible_rsa.pub
cd bootstrap
echo 'Run ansible-playbook -i hosts -u root bootstrap.yml'
ansible-playbook -i hosts -u root bootstrap.yml
cd ..

echo 'Run ansible-playbook -i hosts --extra-vars "accelerate=true" site.yml'
ansible-playbook -i hosts --extra-vars "accelerate=true" site.yml

cd /tmp
git clone https://${GH_OAUTH_TOKEN}@github.com/${GH_USER_NAME}/${GH_PROJECT_NAME} hadoop-ansible
cd hadoop-ansible

echo '---- Set git settings ----'
git config --global user.name $GIT_AUTHOR_NAME
git config --global user.email $GIT_AUTHOR_EMAIL

mkdir ci
mkdir ci/$TRAVIS_BUILD_NUMBER
cd ci/$TRAVIS_BUILD_NUMBER
phantomjs screenshot.js http://hmaster01:50070 active-namenode.png
phantomjs screenshot.js http://hmaster02:50070 standby-namenode.png
phantomjs screenshot.js http://hmaster01:60010/master-status hbase.png
phantomjs screenshot.js http://monitor01/ganglia ganglia.png
phantomjs screenshot.js http://monitor01/kibana/index.html#/dashboard/file/logstash.json kibana.png
phantomjs screenshot.js http://monitor01:9200/_plugin/head/ elasticsearch-head.png
phantomjs screenshot.js http://monitor01:9200/_plugin/bigdesk/ elasticsearch-bigdesk.png
git add .
git commit -m "[ci skip] Screenshots committed by Travis-CI"
git push https://${GH_OAUTH_TOKEN}@github.com/${GH_USER_NAME}/${GH_PROJECT_NAME} 2>&1

echo 'Destroying DigitalOcean instances...'
sudo /etc/rc6.d/K10do_destroy.sh