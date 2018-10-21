#!/bin/bash

yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install ansible

cd /home/vagrant/provision
ansible-playbook playbooks/environment.yml