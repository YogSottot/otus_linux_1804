# Keepalived role
Install Keepalive on Centos/Red Hat with Ansible

## Installation

- In your playbook:

```yaml
- hosts: keepalived_master
  user: root
  become: true
  become_user: root
  roles:
    - keepalived
  vars:
    interface: eth1
    virtual_router_id: 1
    virtual_ipaddress: 10.0.26.81
    priority: 101
    secret_passwd: ZcnG9lGUoZeM3nFT

- hosts: keepalived_backup
  user: root
  become: true
  become_user: root
  roles:
    - keepalived
  vars:
    interface: eth1
    virtual_router_id: 1
    virtual_ipaddress: 10.0.26.81
    priority: 100
    secret_passwd: ZcnG9lGUoZeM3nFT
```

- In your inventory file:

```
[keepalived_master]
lbl1  ansible_ssh_host=10.0.26.201

[keepalived_backup]
lbl2  ansible_ssh_host=10.0.26.202
```

## Synopsis
Install keepalived and configure master and backup.
Default keepalived.config template ```templates/keepalived.conf.j2```.