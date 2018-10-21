# HAProxy
Install HAProxy on Centos/Red Hat with Ansible

## Installation

- In your playbook:

```yaml
roles:
  - haproxy
```

## Synopsis
Installs haproxy and configures backends and frontends, also includes the default haproxy configuration but will use ```templates/haproxy.cfg.j2``` in the process.
