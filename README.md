Simple setup for testing Puppet scripts in isolation on a isolated "machine" with Docker. See http://docker.io for how it works with Linux Containers.

# Running
The script should be self contained so just run ./test-docker.sh to test the Puppet scripts that you have in ./manifests . Add modules to ./modules .

When you run the script the second time, the container will be re-used so only changes in the Puppet scripts should be applied.

# Forcing a reset
To make sure you start a new machine from scratch and apply all the changes you will have to kill the running container in docker. Find and kill like this:

```
vagrant@precise64:~/puppet-docker$ docker ps
ID                  IMAGE                    COMMAND             CREATED             STATUS              PORTS
c3a9324bad55        puppet-testbase:latest   /usr/sbin/sshd -D   6 minutes ago       Up 6 minutes        49153->22           
vagrant@precise64:~/puppet-docker$ docker kill c3a9324bad55
```

# Other stuff
When you run the first time, a Docker image is built called puppet-testbase. If you do any changes to the bash scripts or the Dockerfile you will need to delete it to re-trigger a build:

```
vagrant@precise64:~/puppet-docker$ docker rmi puppet-testbase
```

# More
Just let me know if I can help with anything. And have a look at Docker, it's some truly kick ass technology.
