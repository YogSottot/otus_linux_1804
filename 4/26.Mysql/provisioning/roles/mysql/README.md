Role Name
=========

Basic mysql roles.

Requirements
------------

This role assumes RHEL7 operating system.

Role Variables
--------------

- percona_yum_repo: URL to percona repo RPM
- mysqld: Dictionary with my.cnf settings

Dependencies
------------

None

Example Playbook
----------------

    - hosts: servers
      roles:
         - mysql

License
-------

BSD

Author Information
------------------

Robert dot Barabas () percona ! com
