#!/bin/bash
# Should this have -eu ? Gives weird behaviour?

echo "Updating system and adding required packages..."

if test -f /etc/redhat-release ; then
  echo "sslverify=false" >> /etc/yum.conf
  yum update -y
  rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
  yum install puppet git nano openssh-server passwd rubygems ruby-devel make gcc -y
elif grep -q 'DISTRIB_ID=Ubuntu' /etc/lsb-release ; then
  apt-get update
  apt-get install -y puppet git openssh-server vim rubygems ruby-dev make gcc
fi
echo "Installing librarian-puppet, this might take a while... :)"
sh -c "gem install librarian-puppet"
