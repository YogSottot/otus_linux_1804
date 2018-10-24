Percona Host
============
- Installs Percona XtraDB Cluster (or Server) 5.7 on CentOS 7.4
- Firewalld rules configured based on selected install (cluster or server)
- Generates TLS certificates (requires Galaxy role [easypath.generate-tls-certs](https://galaxy.ansible.com/easypath/generate-tls-certs/))

**WARNING: re-running certificate generation in the same output folder will overwrite any existing certs and keys!**

**NOTE**: SELinux needs to be in permissive mode or disabled if using Percona XtraDB clustering; see offical [install guide](https://www.percona.com/doc/percona-xtradb-cluster/LATEST/install/yum.html)


Role Variables
--------------
- See `defaults/main.yml`


Example Playbook
----------------
```
- hosts: all
  vars_prompt:
    - name: "config_cluster"
      prompt: "> Install Percona XtraDB Cluster?"
      private: no
      default: true

    - name: "config_fw"
      prompt: "> Configure firewall rules?"
      private: no
      default: true

  tasks:
    - name: Install Percona
      import_role: 
        name: percona-host
```


License
-------
BSD


Author Information
------------------
[EasyPath IT Solutions Inc.](https://www.easypath.ca)

