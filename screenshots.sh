#!/bin/sh

cd /tmp
git clone https://${GH_OAUTH_TOKEN}@github.com/${GH_USER_NAME}/${GH_PROJECT_NAME} hadoop-ansible
cd hadoop-ansible

git config --global user.name $GIT_AUTHOR_NAME
git config --global user.email $GIT_AUTHOR_EMAIL
git config --global push.default matching

mkdir ci/$TRAVIS_BUILD_NUMBER
cd ci/$TRAVIS_BUILD_NUMBER

slimerjs ../../screenshot.js http://hmaster01:50070 active-namenode.png
slimerjs ../../screenshot.js http://hmaster02:50070 standby-namenode.png
slimerjs ../../screenshot.js http://hmaster01:60010 hbase.png
slimerjs ../../screenshot.js http://monitor01/ganglia ganglia.png
slimerjs ../../screenshot.js http://monitor01/kibana/index.html\#/dashboard/file/logstash.json kibana.png

git add .
git commit -m "[ci skip] Screenshots committed by Travis-CI"
git push https://${GH_OAUTH_TOKEN}@github.com/${GH_USER_NAME}/${GH_PROJECT_NAME} 2>&1