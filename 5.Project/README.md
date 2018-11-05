### Проект
#### кластеризация web-проекта

**Условия:**  
- можно взять cms: к примеру wordpress или законтактировать с коллегами с других курсов и кластеризуем его  
должны быть:  
- кластеризация и балансировка веба  
- кластеризация и балансировка базы (mysql, postgress- на выбор )  

**Реализации:**  
- ansible роли для развертывания  
- vagrant стенд  

**Что должно быть включено в проект:**  
- минимум 2 ноды под базу  
- минимум 2 ноды под web-сервер  
- настройка файрволла  
- скрипты бэкапа  
- лог-сервер  


**Выполнение:**  

- Схема (нажать, чтобы увидеть в полном размере):
![schema](https://raw.githubusercontent.com/YogSottot/otus_linux_1804/master/5.Project/Networkchart_cluster.svg?sanitize=true)

2 балансировщика с общим ip (VRRP/failover):  
- keepalived (реализует VRRP и следит за состоянием сервисов HAProxy / Galera Arbitrator)  
- HAProxy (проксирование трафика на nginx в web1/web2). Пользователи подключаются к сайту через HAProxy по единому виртуальному ip-адресу

3 web-сервера:  
- nginx  
- php-fpm  
- filebeat  
- GlusterFS (синхронизация файлов сайта и сессий php)
- ProxySQL-Cluster 

3 сервера БД:  
- Percona XtraDB Cluster (Master-Master)  
- filebeat  

1 сервер для логирования и бэкапов:  
- elasticsearch  
- kibana  
- ftp  

**Примечания:**  
- Если тестирование будет не в vagrant, то host-файл должен иметь структуру по предоставленному образцу.  
  При этом нужно обязательно поменять:  

```
  -   vars:
       xtradb_bind_interface: eth1
  -   vars:
       interface: eth1
       virtual_ipaddress: 10.0.5.81
```

- Тестирование в vagrant нужно проводить такой командой (если запускать как обычно, то gluster не соберётся): 
```bash
vagrant up --no-provision
ansible-playbook provisioning/playbook.yml
```

- На всех узлах активирован selinux enforsing targeted. Работе кластера он не препятствует (добавлены правила и модули).  
	Однако, есть ряд багов, которые не позволяют указывать контекст для файловых систем смонтированных через FUSE.  
	[Support SELinux extended attributes on Gluster Volumes](https://github.com/gluster/glusterfs-specs/blob/master/accepted/SELinux-client-support.md)  

- На узлах настроены разные зоны в firewalld.  
	- порты на узлах Percona XtraDB Cluster доступны только друг для друга и для proxysql  
	- интерфейс администрирования proxysql доступен только другим узлам proxysql   
	- порты необходимые для работы glusterfs открыты только для других узлов glusterfs  
	- порт http на web-узлах доступен только для узлов-балансировщиков  

- Используется Percona XtraDB Cluster с синхронной Master-Master репликацией (Galera).  
	- При корректном отключении до 2-х узлов (systemctl stop mysql) оставшийся узел останется в синхронизированном состоянии и продолжит обслуживать клиентов.  
	- При аварийном завершении одного узла (pkill -9 mysql), оставшиеся два узла будут в синхронизированном состоянии и продолжат обслуживать клиентов.  
	- При аварийном завершении двух узлов, оставшийся будет в non-primary state и не будет обслуживать клиентов. При восстановлении работы упавших узлов, синхронизация произойдёт автоматически.  

- ProxySQL-Cluster - обеспечивает прозрачное (для веб-приложения) разделение чтения/записи на разные узлы кластера. Для предотвращения deadlocks, запись, в один момент времени, идёт только на один узел. В случае его падения, запись автоматически переходит на следующий узел.  
[Please note that proxysql_galera_checker will be deprecated in 2.0, with native support for Galera]  

<details><summary>proxysql_galera_checker.sh SUMMARY (нажать, чтобы открыть)</summary><p>

```bash
Mon Nov  5 11:32:12 MSK 2018 ###### proxysql_galera_checker.sh SUMMARY ######
Mon Nov  5 11:32:12 MSK 2018 Hostgroup writers 1
Mon Nov  5 11:32:12 MSK 2018 Hostgroup readers 2
Mon Nov  5 11:32:12 MSK 2018 Number of writers 1
Mon Nov  5 11:32:12 MSK 2018 Writers are readers 1
Mon Nov  5 11:32:12 MSK 2018 log file /var/lib/proxysql/proxysql_galera_checker.log
Mon Nov  5 11:32:12 MSK 2018 ###### HANDLE WRITER NODES ######
Mon Nov  5 11:32:12 MSK 2018 --> Checking WRITE server 1:10.0.5.31:3306, current status ONLINE, wsrep_local_state 4
Mon Nov  5 11:32:12 MSK 2018 server 1:10.0.5.31:3306 is already ONLINE: 1 of 1 write nodes
Mon Nov  5 11:32:12 MSK 2018 --> Checking WRITE server 1:10.0.5.32:3306, current status ONLINE, wsrep_local_state 4
Mon Nov  5 11:32:12 MSK 2018 Changing server 1:10.0.5.32:3306 to status OFFLINE_SOFT. Reason: max write nodes reached (1)
Mon Nov  5 11:32:13 MSK 2018 --> Checking WRITE server 1:10.0.5.33:3306, current status ONLINE, wsrep_local_state 4
Mon Nov  5 11:32:13 MSK 2018 Changing server 1:10.0.5.33:3306 to status OFFLINE_SOFT. Reason: max write nodes reached (1)
Mon Nov  5 11:32:13 MSK 2018 ###### HANDLE READER NODES ######
Mon Nov  5 11:32:13 MSK 2018 --> Checking READ server 2:10.0.5.32:3306, current status ONLINE, wsrep_local_state 4
Mon Nov  5 11:32:13 MSK 2018 server 2:10.0.5.32:3306 is already ONLINE
Mon Nov  5 11:32:13 MSK 2018 --> Checking READ server 2:10.0.5.33:3306, current status ONLINE, wsrep_local_state 4
Mon Nov  5 11:32:13 MSK 2018 server 2:10.0.5.33:3306 is already ONLINE
Mon Nov  5 11:32:13 MSK 2018 --> Checking READ server 2:10.0.5.31:3306, current status ONLINE, wsrep_local_state 4
Mon Nov  5 11:32:13 MSK 2018 server 2:10.0.5.31:3306 is already ONLINE
```
</p></details>

- Создано 3 узла Glusterfs для избежания split-brain. При падении двух узлов, оставшийся не будет обслуживать клиентов.

- Развёртывается чистый дистрибутив wordpress. После запуска кластера, по адресу виртуального ip попадёте на стадию установки пароля и логина администратора wordpress. Проверены: загрузка файлов в медиабиблиотеку, создание новых записей, установка плагинов.

<details><summary>wordpress (нажать, чтобы открыть)</summary><p>

![wordpress](https://i.imgur.com/hkSU4ug.png)  

</p></details>

- Сессии синхронизируются через gluster, так как в memcache нет репликации, а redis требует минимум 6 узлов (3 master, 3 slave)  

- Бэкап производится скриптом на python. БД через xtrabackup. Сайт через упаковку в архив. Бэкапы заливаются на сервер бэкапов по крону.

- Опция   ```network.ping-timeout: 5``` позволяет значительно снизить время лага при падении узла glusterfs.  По умолчанию 60 секунд.  

<details><summary>gluster volume info (нажать, чтобы открыть)</summary><p>

```bash
[root@web2 vagrant]# gluster volume info 
 
Volume Name: php
Type: Replicate
Volume ID: 5e95467e-ed46-41c5-b44b-8657e01bcf05
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 3 = 3
Transport-type: tcp
Bricks:
Brick1: 10.0.5.21:/srv/gluster/php
Brick2: 10.0.5.22:/srv/gluster/php
Brick3: 10.0.5.23:/srv/gluster/php
Options Reconfigured:
performance.cache-size: 256MB
network.ping-timeout: 5
transport.address-family: inet
nfs.disable: on
performance.client-io-threads: off
 
Volume Name: wordpress
Type: Replicate
Volume ID: cc270d1d-504d-4d4f-8a10-c22bb116d92e
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 3 = 3
Transport-type: tcp
Bricks:
Brick1: 10.0.5.21:/srv/gluster/wordpress
Brick2: 10.0.5.22:/srv/gluster/wordpress
Brick3: 10.0.5.23:/srv/gluster/wordpress
Options Reconfigured:
performance.cache-size: 256MB
network.ping-timeout: 5
transport.address-family: inet
nfs.disable: on
performance.client-io-threads: off
```

</p></details>

<details><summary>gluster volume status (нажать, чтобы открыть)</summary><p>

```bash
 gluster volume status
Status of volume: php
Gluster process                             TCP Port  RDMA Port  Online  Pid
------------------------------------------------------------------------------
Brick 10.0.5.21:/srv/gluster/php            49153     0          Y       5777 
Brick 10.0.5.22:/srv/gluster/php            49153     0          Y       7533 
Brick 10.0.5.23:/srv/gluster/php            49153     0          Y       6016 
Self-heal Daemon on localhost               N/A       N/A        Y       7556 
Self-heal Daemon on 10.0.5.23               N/A       N/A        Y       6039 
Self-heal Daemon on 10.0.5.21               N/A       N/A        Y       5800 
 
Task Status of Volume php
------------------------------------------------------------------------------
There are no active volume tasks
 
Status of volume: wordpress
Gluster process                             TCP Port  RDMA Port  Online  Pid
------------------------------------------------------------------------------
Brick 10.0.5.21:/srv/gluster/wordpress      49152     0          Y       5701 
Brick 10.0.5.22:/srv/gluster/wordpress      49152     0          Y       7457 
Brick 10.0.5.23:/srv/gluster/wordpress      49152     0          Y       5612 
Self-heal Daemon on localhost               N/A       N/A        Y       7556 
Self-heal Daemon on 10.0.5.23               N/A       N/A        Y       6039 
Self-heal Daemon on 10.0.5.21               N/A       N/A        Y       5800 
 
Task Status of Volume wordpress
------------------------------------------------------------------------------
There are no active volume tasks
```

</p></details>

<details><summary>gluster peer status (нажать, чтобы открыть)</summary><p>

```bash
[root@web2 vagrant]# gluster peer status
Number of Peers: 2

Hostname: 10.0.5.23
Uuid: c898bc81-1f9f-4941-a608-7d45ab22c91f
State: Peer in Cluster (Connected)

Hostname: 10.0.5.21
Uuid: 4ebe85e0-6f14-4f7d-8fd6-9f4314a0fee2
State: Peer in Cluster (Connected)
```

</p></details>

<details><summary>show status like 'wsrep%' (нажать, чтобы открыть)</summary><p>

```bash
mysql> show status like 'wsrep%';
+----------------------------------+----------------------------------------------------------+
| Variable_name                    | Value                                                    |
+----------------------------------+----------------------------------------------------------+
| wsrep_local_state_uuid           | bca419cf-dea0-11e8-9614-472050e4d128                     |
| wsrep_protocol_version           | 9                                                        |
| wsrep_last_applied               | 11                                                       |
| wsrep_last_committed             | 11                                                       |
| wsrep_replicated                 | 0                                                        |
| wsrep_replicated_bytes           | 0                                                        |
| wsrep_repl_keys                  | 0                                                        |
| wsrep_repl_keys_bytes            | 0                                                        |
| wsrep_repl_data_bytes            | 0                                                        |
| wsrep_repl_other_bytes           | 0                                                        |
| wsrep_received                   | 7                                                        |
| wsrep_received_bytes             | 590                                                      |
| wsrep_local_commits              | 0                                                        |
| wsrep_local_cert_failures        | 0                                                        |
| wsrep_local_replays              | 0                                                        |
| wsrep_local_send_queue           | 0                                                        |
| wsrep_local_send_queue_max       | 1                                                        |
| wsrep_local_send_queue_min       | 0                                                        |
| wsrep_local_send_queue_avg       | 0.000000                                                 |
| wsrep_local_recv_queue           | 0                                                        |
| wsrep_local_recv_queue_max       | 1                                                        |
| wsrep_local_recv_queue_min       | 0                                                        |
| wsrep_local_recv_queue_avg       | 0.000000                                                 |
| wsrep_local_cached_downto        | 0                                                        |
| wsrep_flow_control_paused_ns     | 0                                                        |
| wsrep_flow_control_paused        | 0.000000                                                 |
| wsrep_flow_control_sent          | 0                                                        |
| wsrep_flow_control_recv          | 0                                                        |
| wsrep_flow_control_interval      | [ 173, 173 ]                                             |
| wsrep_flow_control_interval_low  | 173                                                      |
| wsrep_flow_control_interval_high | 173                                                      |
| wsrep_flow_control_status        | OFF                                                      |
| wsrep_cert_deps_distance         | 0.000000                                                 |
| wsrep_apply_oooe                 | 0.000000                                                 |
| wsrep_apply_oool                 | 0.000000                                                 |
| wsrep_apply_window               | 0.000000                                                 |
| wsrep_commit_oooe                | 0.000000                                                 |
| wsrep_commit_oool                | 0.000000                                                 |
| wsrep_commit_window              | 0.000000                                                 |
| wsrep_local_state                | 4                                                        |
| wsrep_local_state_comment        | Synced                                                   |
| wsrep_cert_index_size            | 0                                                        |
| wsrep_cert_bucket_count          | 22                                                       |
| wsrep_gcache_pool_size           | 1592                                                     |
| wsrep_causal_reads               | 0                                                        |
| wsrep_cert_interval              | 0.000000                                                 |
| wsrep_open_transactions          | 0                                                        |
| wsrep_open_connections           | 0                                                        |
| wsrep_ist_receive_status         |                                                          |
| wsrep_ist_receive_seqno_start    | 0                                                        |
| wsrep_ist_receive_seqno_current  | 0                                                        |
| wsrep_ist_receive_seqno_end      | 0                                                        |
| wsrep_incoming_addresses         | 192.168.0.133:3306,192.168.0.132:3306,192.168.0.131:3306 |
| wsrep_cluster_weight             | 3                                                        |
| wsrep_desync_count               | 0                                                        |
| wsrep_evs_delayed                |                                                          |
| wsrep_evs_evict_list             |                                                          |
| wsrep_evs_repl_latency           | 0.000538706/0.00661727/0.0185985/0.00706663/4            |
| wsrep_evs_state                  | OPERATIONAL                                              |
| wsrep_gcomm_uuid                 | 9f48f6a4-dea3-11e8-b931-9bf966e6d3e6                     |
| wsrep_cluster_conf_id            | 3                                                        |
| wsrep_cluster_size               | 3                                                        |
| wsrep_cluster_state_uuid         | bca419cf-dea0-11e8-9614-472050e4d128                     |
| wsrep_cluster_status             | Primary                                                  |
| wsrep_connected                  | ON                                                       |
| wsrep_local_bf_aborts            | 0                                                        |
| wsrep_local_index                | 1                                                        |
| wsrep_provider_name              | Galera                                                   |
| wsrep_provider_vendor            | Codership Oy <info@codership.com>                        |
| wsrep_provider_version           | 3.31(rf216443)                                           |
| wsrep_ready                      | ON                                                       |
+----------------------------------+----------------------------------------------------------+
71 rows in set (0.19 sec)
```

</p></details>

- kiabana и elastic закрыты через basic http auth. Логин / Пароль от kibana по умолчанию (otus / test).  

<details><summary>kiabana (нажать, чтобы открыть)</summary><p>

![kibana](https://i.imgur.com/i7OZxnO.png)  
![kibana](https://i.imgur.com/xjQtnPr.png)  

</p></details>
  
  
**Использованные роли:**  
https://github.com/liviuchircu/ansible-role-XtraDB-Cluster  
https://github.com/timorunge/ansible-proxysql  
https://github.com/torian/ansible-role-filebeat  
https://github.com/geerlingguy/ansible-role-elasticsearch-curator  
https://github.com/geerlingguy/ansible-role-glusterfs  
https://github.com/neb0t/vagrant-ansible-haproxy-keepalived  
https://github.com/ansible/ansible-examples/tree/master/wordpress-nginx  

**Использованная документация:**  
https://www.percona.com/doc/percona-xtradb-cluster/LATEST/index.html  
https://github.com/sysown/proxysql/wiki  
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/sect-security-enhanced_linux-troubleshooting-fixing_problems#sect-Security-Enhanced_Linux-Fixing_Problems-Linux_Permissions  
https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-modules.html  
