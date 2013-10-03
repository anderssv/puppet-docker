#!/bin/bash -eu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PUPPET_DIR="${PUPPET_SOURCE:-$SCRIPT_DIR/puppet}"
DOCKER_DIR="$SCRIPT_DIR/docker"
DOCKER_PUPPET_IMAGE="puppet-testbase"
DOCKER_OS="${DOCKER_OS:-CENTOS}"

# Support setting a special puppet dir. This is mainly to support running in Vagrant.
if [[ -e /puppet ]]; then
	PUPPET_DIR="/puppet"
fi

function puppetImage() {
	echo "$(imagePulled $DOCKER_PUPPET_IMAGE)"
}

function imagePulled() {
	local IMAGE_NAME=$1
	echo "$(docker images | { grep $IMAGE_NAME || true; })"
}

function dockerVersion() {
	echo "$(docker version | grep Server | cut -d ":" -f2 | tr -d ' ')"
}

function dnsIp() {
	echo "$(echo $(hostIp) | cut -f1-3 -d '.').2"
}

function hostIp() {
	echo "$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"
}

function dockerRunning() {
	local DOCKER_PS="$1"
	if [[ "$(docker ps | grep $DOCKER_PS)" ]]; then
		echo "true"
	fi
}

cd $DOCKER_DIR

# Make sure the key is private, if not ssh will not use it
chmod og-rwx ssh_*

echo " "

DOCKER_PATH=$({ which docker || true; })
if [[ ! $DOCKER_PATH ]]; then
	echo " "
	echo "ERROR: Could not find Docker. Did you install? See README and http://docker.io for instructions."
	echo " "
	exit 1
fi

# Work around for security constraint in docker. Will be fixed later with groups.
sudo chmod 777 /var/run/docker.sock

echo " "
if [[ ! "$(puppetImage)" ]]; then
	echo " "
	echo "Need to build base image for puppet testing!"
	echo "After this is done once, testing will run faster. :)"
	echo " "
	if test ${DOCKER_OS} == CENTOS ; then
		sed -i 's/^FROM\s\+.*$/FROM centos/' ${DOCKER_DIR}/Dockerfile
	elif test ${DOCKER_OS} == UBUNTU ; then
		sed -i 's/^FROM\s\+.*$/FROM ubuntu/' ${DOCKER_DIR}/Dockerfile
	else
		echo "DOCKER_OS: ${DOCKER_OS} not supported only CENTOS and UBUNTU at the moment"
		exit 1
	fi
	echo "Building ${DOCKER_OS} image..."
	docker build -t="$DOCKER_PUPPET_IMAGE" .
fi

if [[ ! "$(puppetImage)" ]]; then
	echo "Building the puppet image has failed! Aborting."	
	exit 1
fi

DOCKER_PS=$(cat $DOCKER_DIR/docker.pid || true;)
# If already created and still running. Stop the container to create a new one.
if [[ "$(dockerRunning "$DOCKER_PS")" ]]; then
	echo " "
	echo "Existing container found $DOCKER_PS, using that"
else
	echo " "
	echo "Creating docker container with SSH"
	echo "Command: docker run -d -h 'puppettest.localdomain' -p 22 -t -v $PUPPET_DIR:/puppet -v $DOCKER_DIR:/docker $DOCKER_PUPPET_IMAGE /usr/sbin/sshd -D"
	DOCKER_PS=$(docker run -d -h "puppettest.localdomain" -p 22 -t -v $PUPPET_DIR:/puppet -v $DOCKER_DIR:/docker $DOCKER_PUPPET_IMAGE /usr/sbin/sshd -D)
	echo $DOCKER_PS > $DOCKER_DIR/docker.pid
	echo "Docker container started: $DOCKER_PS"
	echo " "
fi

echo " "
echo "Running puppet"
echo " "
# Sleeping to let everything start up. Nasty...
sleep 1s
SSH_PORT=$(docker port $DOCKER_PS 22)
ssh -q -i ssh_key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@localhost -p $SSH_PORT "/docker/run_puppet.sh"

echo " "
echo " Done ! $(date)"
echo " "
