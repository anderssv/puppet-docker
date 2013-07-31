Simple setup for testing Puppet scripts in isolation on a isolated "machine" with Docker. See http://docker.io for how it works with Linux Containers.

# Requirements
Install Docker according to instructions on http://docker.io . Clone this repository or export contents to a new one you intend to work on Puppet scripts in, and you should be all set.

# Running
The script should be self contained so just run ```./test-docker.sh``` to test the Puppet scripts that you have in ```./puppet/manifests``` . Add modules to ```./puppet/modules``` .

When you run the script the second time, the container will be re-used so only changes in the Puppet scripts should be applied.

# Forcing a reset
To make sure you start a new machine from scratch and apply all the changes you will have to kill the running container in docker. Find and kill like this:

```
vagrant@precise64:~/puppet-docker$ docker ps
ID                  IMAGE                    COMMAND             CREATED             STATUS              PORTS
c3a9324bad55        puppet-testbase:latest   /usr/sbin/sshd -D   6 minutes ago       Up 6 minutes        49153->22           
vagrant@precise64:~/puppet-docker$ docker kill c3a9324bad55
```

# Puppet sources
Because this uses the folder ```./puppet``` you can create a symlink to a different folder as long as it contains a modules and manifests folder. This is done so that you can use this project to test any puppet project without including all these files and setup.

# Vagrant???
Docker only runs on Ubuntu at the moment. So if you'd like to run this on anything else you can use Vagrant to launch a Ubuntu VM (like I do on OS X). The first launch will be slow, but after the first launch Vagrant shouldn't get in your way. The folder you start up in is mapped to ```/vagrant``` inside the box so the sources and scripts will be triggered there. Login and do:

```
vagrant up (wait for everything to finish)
vagrant reload
vagrant ssh
cd /vargant
./test-docker.sh
```

# Reducing test time
When you run the first time, a Docker image is built called puppet-testbase. The next time it is run, this will be skipped and the testing will be a lot faster. If you do any changes to the bash scripts or the Dockerfile you will need to delete it to re-trigger a build:

```
vagrant@precise64:~/puppet-docker$ docker rmi puppet-testbase
```

# More
Just let me know if I can help with anything. And have a look at Docker, it's some truly kick ass technology.
