# Ansible configuration

- [Roles](#roles)
- [Ansible Playbooks](#ansible-playbooks)

## Roles

Environment roles:

- [common] (provision/roles/common/README.md)
- [haproxy](provision/roles/haproxy/README.md)
- [nginx](provision/roles/nginx/README.md)

## Ansible Playbooks

All playbooks avaible in [playbooks folder](playbooks). Run Playbooks you can follows:

```
ansible-playbook playbooks/your-role.yml
```

#Deploying HAProxy with Keepalived and Nginx via Ansible

#Infrastructure

###SPECIFICATION

Environment has 2 Nginx servers.
Has 2 load balancer based on HAProxy.
Environment can be deployed via `vagrant up` command.


# SETUP REQUIRMENTS 

Tools needed for Environment setup:

1. Installed Virtualbox (=5.1.12 version)
2. Installed Vagrant (>=1.9.1 version)
3. Imported Centos 7 box (`vagrant box add cent0s7 image.box`)

By default ansible is using `vagrant` username and `vagrant` password for ssh connection.

You can change those parameters in `group_vars/all`.

## Managment instance
Ansible (>=2.0.2) version installed

## Webservers role
Commons installed;
Nginx installed;

## Load balancer server
Haproxy installed;

## Keepalived master server
Haproxy installed;
Keepalived installed;

## Keepalived backup server
Haproxy installed;
Keepalived installed;

# Deploy process instruction:

Clone git project to vagrant host.

`git clone https://github.com/neb0t/vagrant-ansible-haproxy-keepalived.git`

#Local infrastructure opened on Vagrant VirtualBox

OS: CentOS 7

Network: 10.0.26.0/24

### Hosts

- [ansible]
    - ansible (10.0.26.10)
- [lb] 
    -haproxy1 (10.0.26.201)
    -haproxy2 (10.0.26.202)
- [webapp]
    - web1 (10.0.26.101)
    - web2 (10.0.26.102)

Up/Down all virtual hosts ```vagrant up``` / ```vagrant halt```

Up/Down single virtual host ```vagrant up web1``` / ```vagrant halt web1```

#Web-pages access

###Web servers
web1: http://10.0.26.201

web2: http://10.0.26.202

###Load balancer server
lb1: http://10.0.26.101
lb2: http://10.0.26.102

####LB Statistic page
http://127.0.0.1:8080/stats

    username: stat
    password: statpass