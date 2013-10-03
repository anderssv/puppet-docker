#!/bin/bash
# Should this have -eu ? Gives weird behaviour?

echo "Updating system and adding required packages..."

yum update -y
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install puppet git nano openssh-server passwd rubygems ruby-devel make gcc -y

echo "Installing librarian-puppet, this might take a while... :)"
sh -c "gem install librarian-puppet"
