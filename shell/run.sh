#!/bin/bash
# start run and listen

/usr/sbin/sshd-keygen 
cat /etc/ssh/ssh_host_rsa_key.pub > ~/.ssh/authorized_keys
chmod 644 ~/.ssh/authorized_keys 
cat /etc/ssh/ssh_host_rsa_key > /id_rsa
/usr/sbin/sshd $1