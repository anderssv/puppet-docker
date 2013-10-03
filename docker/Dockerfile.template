# VERSION               0.1
# DOCKER-VERSION        0.4

FROM    DOCKER_OS

# Update system and packages
ADD     system_packages_DOCKER_OS.sh /root/system_packages.sh
RUN     /root/system_packages.sh

# Add configuration for SSH daemon
ADD     ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
ADD     ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
ADD     sshd_config /etc/ssh/sshd_config

# Add configuration for SSH-ing and pulling from Git repo
ADD     ssh_key.pub /root/.ssh/authorized_keys
ADD     ssh_key.pub /root/.ssh/id_rsa.pub
ADD     ssh_key /root/.ssh/id_rsa
ADD     ssh_config /root/.ssh/config
RUN     chmod 700 /root/.ssh && chown root:root /root/.ssh/* && chmod 600 /root/.ssh/*

# Set password to fixed value
RUN     echo "root:puppet" | chpasswd -
