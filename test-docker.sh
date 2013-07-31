#!/bin/bash -eu

DOCKER_PUPPET_IMAGE="puppet-testbase"

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

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $SCRIPT_DIR/docker

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

echo " "
if [[ ! "$(puppetImage)" ]]; then
	echo " "
	echo "Need to build base image for puppet testing!"
	echo "After this is done once, testing will run faster. :)"
	echo " "
	docker build -t="$DOCKER_PUPPET_IMAGE" .
fi

if [[ ! "$(puppetImage)" ]]; then
	echo "Building the puppet image has failed! Aborting."	
	exit 1
fi

# If already created and still running. Stop the container to create a new one.
if [[ -e docker.pid && "$(docker ps | grep $(cat docker.pid))" ]]; then
	echo " "
	echo "Existing container found $(cat docker.pid), using that"
	DOCKER_PS=$(cat docker.pid)
else
	echo " "
	echo "Creating docker container with SSH"
	DOCKER_PS=$(docker run -d -h "puppettest.localdomain" -p 22 -t -v $SCRIPT_DIR:/puppet $DOCKER_PUPPET_IMAGE /usr/sbin/sshd -D)
	echo $DOCKER_PS > docker.pid
	echo "Docker container started: $DOCKER_PS"
	echo " "
fi

echo " "
echo "Running puppet"
echo " "
SSH_PORT=$(docker port $DOCKER_PS 22)
ssh -q -i ssh_key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$(hostIp) -p $SSH_PORT "./run_puppet.sh"

echo " "
echo " Done ! $(date)"
echo " "
