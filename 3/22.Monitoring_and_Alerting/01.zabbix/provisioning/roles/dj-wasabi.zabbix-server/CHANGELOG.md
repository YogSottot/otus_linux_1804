# ansible-zabbix-server Release

Below an overview of all changes in the releases.

Version (Release date)

1.1.0   (2018-05-20)

  * Use the service for ubuntu 14.04
  * Use the `zabbix_server_database` and `zabbix_server_database_long` as how it is documented
  * Support Debian 9
  * Use Ansible 2.4 as minimum version
  * Fixed/Removed some deprecation warnings
  * Use specific version of libraries #87
  * Postgresql 10 support #73 (By pull request: eshikhov (Thanks!))
  * Update README.md #76 (By pull request: aminmaghsodi (Thanks!))
  * Update RedHat.yml #82 (By pull request: tshtilman (Thanks!))
  * Testing with Molecule V2

1.0.0   (2017-08-30)

  * From ini to yml style.
  * Replace shell tasks with modules.
  * Installing default 3.4.
  * Prefixed all properties that started with `server_` with the value `zabbix_`.
  * Added upgrade part in documentation.
  * Documentation: Fix Formatting #71 (By pull request: fxfitz (Thanks!))
  * Fix permissions on Zabbix includedir #68 (By pull request: clement-lefevre (Thanks!))
  * Set Molecule to V1 for now since V2 is released.

0.8.0   (2017-06-16)

  * Changed the dependency-definition to get rid of a deprecation warning #41 (By pull request: madonius (Thanks!))
  * Using a changed_when to fool ansible-lint #42
  * Create vhost config in correct directory and link to enable #47 (By pull request: stephankn (Thanks!))
  * Removing not needed ServerAlias entry #48
  * Updating when statement due to comment #50
  * Renaming docker-py to docker #54
  * skip steps related to zabbix-web package when not installing it #56 (By pull request: flyapen (Thanks!))
  * Fix for Wrong directory api instead of app in apache_vhost.conf.j2 #53

0.7.0   (2016-12-30)

  * Set up distributive-related config-ownership #40 (By pull request: envrm (Thanks!))
  * fix apache restart when using tag 'apache' … #39 (By pull request: lhoss (Thanks!))
  * debian/ubuntu: install postgresql-client pkg (instead of postgresql which contains the postgres server) #38 (By pull request: lhoss (Thanks!))
  * fix early failures when running the zabbix-server playbook in check-mode #37 (By pull request: lhoss (Thanks!))
  * Update main.yml #36 (By pull request: cognoscibilis (Thanks!))
  * Configurable zabbix server port and database port #34 (By pull request: vincepii (Thanks!))
  * debian and ubuntu repository install was generalized #32 (By pull request: matheuscunha (Thanks!))
  * Zabbix 3.2.0

0.6.0   (2016-08-24)

  * Removed Test Kitchen tests, added molecule tests
  * Added collation and encoding for MySQL databases #23
  * Add SELinux specifics #19 (By pull request: mescanef (Thanks!))
  * Fixes in the README.md file #18 (By pull request: mescanef (Thanks!))
  * Fix for: zabbix_repo - inconsistent use between server and agent roles. #17
  * Fix for: apache 2.2. and 2.4 #15

0.5.1   (2016-04-03)

  * Fix for: zabbix_server.conf file mode #14
  * Fix for: Support for v3+ Server Configuration #13

0.5.0   (2016-03-28)

  * Zabbix 3.0
  * MySQL database creation on other host (delegation)

0.4.0   (2016-02-05)

  * fix #2: server_dbhost allows for remote database but role does not fully support setting up on remote db #11 (By pull request: lhoss (Thanks!))
  * Added basic travis test
  * Fixed installation on Debian / Ubuntu for installing mysqldb-python package.

0.3.0   (2015-11-24)

  * Add test-kitchen #7 (By pull request: kostyrevaa (Thanks!))
  * Force apt cache update after installing Zabbix's gpg key #8 (By pull request: SAL-e (Thanks!))
  * tasks/mysql.yml - [add] install mysql client on RHEL base 7 #9 (By pull request: clopnis (Thanks!))
  * Updated test-kitchen tests
  * Added BATS tests
  * Added CHANGELOG.md file

0.2.1   (2015-06-30)

  * Fix unzip schema files for RedHat #5 (By pull request: kostyrevaa (Thanks!))
  * Fix missed required space #6 (By pull request: kostyrevaa (Thanks!))

0.2.0   (2015-03-20)

  * Various fixes #3 (By pull request: srvg (Thanks!))
  * Add optional configuration for Apache virtualhost aliases #4 (By pull request: srvg (Thanks!))

0.1.0   (2015-02-01)

  * Two minor changes for installation #1 (By pull request: drmikecrowe (Thanks!))

0.0.1   (2014-10-31)

  * Initial creation