Simple setup for testing Puppet scripts in isolation on a isolated "machine" with Docker. See http://docker.io for how it works with Linux Containers.

# Requirements
Install Docker according to instructions on http://docker.io . Clone this repository or export contents to a new one you intend to work on Puppet scripts in, and you should be all set.

If you're not on Ubuntu you'll want to check out the Vagrant section. :)

# Running
The script should be self contained so just run ```./test-docker.sh``` to test the Puppet scripts that you have in ```./puppet/manifests``` . Add modules to ```./puppet/modules``` .

When you run the script the second time, the container will be re-used so only changes in the Puppet scripts should be applied.

# How?
This setup does a few things:
- Install necessary packages for puppet and ssh
- Compile an updated image as a one off to save time later
- Launch a SSH daemon to enable running puppet and debugging
- Run Puppet scripts automatically

Docker containers are low overhead and fast to start up, so the real delay you experience comes from what the puppet scripts does. You only reset (see below) once in a while if there are new versions to Puppet etc.

# Forcing a reset
To make sure you start a new machine from scratch and apply all the changes you will have to kill the running container in docker. Find and kill like this:

```
vagrant@precise64:~/puppet-docker$ docker ps
ID                  IMAGE                    COMMAND             CREATED             STATUS              PORTS
c3a9324bad55        puppet-testbase:latest   /usr/sbin/sshd -D   6 minutes ago       Up 6 minutes        49153->22           
vagrant@precise64:~/puppet-docker$ docker kill c3a9324bad55
```

# Puppet sources
The default setup uses the included ```./puppet``` folder. If you'd like to test some other sources you can point to them by doing ```export PUPPET_SOURCE=/home/user/source/mypuppet```. Do this on your host machine and it will be used by the scripts if you are running in Linux, and picked up by Vagrant (Vagrant will map the dir to ```/puppet```).

# Vagrant???
Docker only runs on Ubuntu at the moment. So if you'd like to run this on anything else you can use Vagrant to launch a Ubuntu VM (like I do on OS X). The first launch will be slow, but after the first launch Vagrant shouldn't get in your way. The folder you start up in is mapped to ```/vagrant``` inside the box so the sources and scripts will be triggered there. Login and do:

```
vagrant up (wait for everything to finish)
vagrant reload
vagrant ssh
cd /vargant
./test-docker.sh (repeat after each change)
```

# Reducing test time
When you run the first time, a Docker image is built called puppet-testbase. The next time it is run, this will be skipped and the testing will be a lot faster. If you do any changes to the bash scripts or the Dockerfile you will need to delete it to re-trigger a build:

```
vagrant@precise64:~/puppet-docker$ docker rmi puppet-testbase
```

# More
Just let me know if I can help with anything. And have a look at Docker, it's some truly kick ass technology.
