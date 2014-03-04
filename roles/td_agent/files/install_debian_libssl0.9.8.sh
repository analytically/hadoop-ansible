#!/usr/bin/env sh

dpkg --list libssl > /dev/null
if [ $? != 0 ]; then
  cd /tmp
  wget http://ftp.us.debian.org/debian/pool/main/o/openssl/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb
  dpkg -i libssl0.9.8_0.9.8o-4squeeze14_amd64.deb
fi