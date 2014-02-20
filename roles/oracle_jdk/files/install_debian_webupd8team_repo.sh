#!/usr/bin/env sh

#see #see http://docs.ansible.com/script_module.html

grep -Fqx "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" /etc/apt/sources.list

if [ $? != 0 ]; then
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
  apt-get update
fi #else already installed



