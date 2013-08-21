#!/bin/bash
# Should this have -eu ? Gives weird behaviour?

echo "Updating system and adding required packages..."

echo "sslverify=false" >> /etc/yum.conf
yum update -y
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install puppet git nano openssh-server passwd rubygems ruby-devel make gcc -y

sh -c "gem install librarian-puppet"
