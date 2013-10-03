#!/bin/bash
# Should this have -eu ? Gives weird behaviour?

echo "Updating system and adding required packages..."

apt-get update
apt-get install -y puppet git openssh-server vim rubygems ruby-dev make gcc
mkdir /var/run/sshd

echo "Installing librarian-puppet, this might take a while... :)"
sh -c "gem install librarian-puppet"
