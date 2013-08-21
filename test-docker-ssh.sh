#!/bin/bash -eu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_DIR="$SCRIPT_DIR/docker"

cd $DOCKER_DIR

function hostIp() {
	echo "$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"
}

function dockerRunning() {
	local DOCKER_PS="$1"
	if [[ "$(docker ps | grep $(cat docker.pid))" ]]; then
		echo "true"
	fi
}

DOCKER_PS=$(cat $DOCKER_DIR/docker.pid || true;)
SSH_PORT=$(docker port $DOCKER_PS 22)
ssh -q -i ssh_key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$(hostIp) -p $SSH_PORT
