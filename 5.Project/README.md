### Проект
#### кластеризация web-проекта

**Условия:**  
- можно взять cms: к примеру wordpress или законтактировать с коллегами с других курсов и кластеризуем его  
должны быть:  
- кластеризация и балансировка веба  
- кластеризация и балансировка базы (mysql, postgress- на выбор )  

**Реализации:**  
- ansible роли для развертывания ( под вагрант / прод)  
- vagrant стенд  

**Что должно быть включено в проект:**  
- минимум 2 ноды под базу  
- минимум 2 ноды под web-сервер  
- настройка файрволла (милитари- демилитаризованная зона)  
- скрипты бэкапа  
- лог-сервер  


**Выполнение:**  

- Схема:
![schema](https://raw.githubusercontent.com/YogSottot/otus_linux_1804/master/5.Project/Networkchart_cluster.svg?sanitize=true)

2 балансировщика с общим ip (VRRP/failover):  
- keepalived (реализует VRRP и следит за состоянием сервисов HAProxy / Galera Arbitrator)  
- HAProxy (проксирование трафика на nginx в web1/web2 и на mysql в db1/db2)  клиенты подклчюаеются к HAProxy по единому виртуальному ip-адресу

3 web-сервера (синхронизация файлов сайта через lsyncd):  
- nginx  
- php-fpm  
- filebeat  
- GlusterFS (синхронизация файлов сайта и сессий php)
- ProxySQL-Cluster - обеспечивает прозрачное для веб-приложения разделение чтения/записи на разные узлы кластера. Для предотвращения deadlocks, запись в один момент времени идёт только на один узел, в случае его падения запись автоматически переходит на следующий узел.  
[в продакшене можно использовать не раньше закрытия этоих багов https://github.com/sysown/proxysql/issues/1745 https://github.com/sysown/proxysql/issues/1039]  
[Please note that proxysql_galera_checker will be deprecated in 2.0 , with native support for Galera]  


3 сервера БД:
- Percona XtraDB Cluster (Master-Master)
- filebeat  

1 сервер для логирования и бэкапов
- elasticsearch
- kibana
- sftp

https://i.imgur.com/i7OZxnO.png
https://i.imgur.com/1B5gb5B.png

https://www.digitalocean.com/community/tutorials/how-to-share-php-sessions-on-multiple-memcached-servers-on-ubuntu-14-04


https://github.com/116davinder/memcached-cluster-ansible
https://github.com/geerlingguy/ansible-role-memcached

https://github.com/liviuchircu/ansible-role-XtraDB-Cluster
https://github.com/timorunge/ansible-proxysql
https://github.com/timorunge/ansible-pmm-client
https://github.com/torian/ansible-role-filebeat


id|active|interval_ms|filename|arg1|arg2|arg3|arg4|arg5|comment
1|1|3000|/bin/proxysql_galera_checker|--config-file=/etc/proxysql-admin.cnf --writer-is-reader=always --write-hg=10 --read-hg=11 --writer-count=1 --mode=singlewrite  --log=/var/lib/proxysql/otus_proxysql_galera_check.log|||||otus

  tags:
  - skip_ansible_lint

  https://github.com/evrardjp/ansible-keepalived
gluster volume info
 gluster volume set wordpress network.ping-timeout 5

audit2why < /var/log/audit/audit.log


TO DO:
проверить перкону с selinux
внести в gluster сессии php - задать session.save_path и upload_tmp_dir
проверить весь кластер



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
