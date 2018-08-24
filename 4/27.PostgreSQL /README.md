### Домашнее задание
#### PostgreSQL

1 **Написать playbook установки postgres**  

- в vars вынести версию, так что бы поддерживалась версия 9.6 и 10  

В postgresql/defaults/main.yml  
Можно поставить в playbook 9.6 или 10  
```bash
   - vars/pg10.yml # or pg9.6.yml 
```
- сконфигурировать pg_hba.conf (пересмотрите слайды)  

Перевёл пользователей на пароли и добавлен .pgpass для пользователя vagrant.  
```bash
[vagrant@slave ~]$ psql -dvagrant
psql (10.5)
Type "help" for help.

vagrant=> \q

[vagrant@slave ~]$ psql -h 192.168.100.11 -dvagrant
psql (10.5)
Type "help" for help.

vagrant=> \q
```

- сконфигурировать postgresql.conf на работу с конкретной машиной (ansible_memtotal_mb вам в помощь)  

```bash
postgresql_tuning_memory_percent: "100" 
postgresql_tuning_memory_mb: "{{ (postgresql_tuning_memory_percent|int / 100 * ansible_memory_mb.real.total)|int }}"

postgresql_shared_buffers: "{{ [(postgresql_tuning_memory_mb|int * 0.25)|int,16384]|min }}MB" 
postgresql_temp_buffers: "{{ [(postgresql_tuning_memory_mb|int * 0.25 / postgresql_max_connections)|int,1]|max }}MB" 
postgresql_work_mem: "{{ [(postgresql_tuning_memory_mb|int * 0.25 / postgresql_max_connections)|int,1]|max }}MB" 
postgresql_maintenance_work_mem: "{{ [(postgresql_tuning_memory_mb|int * 0.15 / postgresql_autovacuum_max_workers|float)|int,1]|max }}MB"
```

2 **Написать playbook разворачивания реплики с помощью pg_basebackup**  

```bash
postgresql_wal_level: "hot_standby"
postgresql_wal_keep_segments: "10"
postgresql_max_wal_senders: "10" 
postgresql_max_replication_slots: "10"
```

```bash
[root@master vagrant]# psql -dtemplate1
psql (10.5)
Type "help" for help.

template1=> SELECT * FROM pg_stat_replication;
  pid  | usesysid | usename  | application_name | client_addr | client_hostname | client_port | backend_start | backend_xmin | state | sent_lsn | write_lsn | flush_lsn | replay_lsn | write_lag | flush_lag | 
replay_lag | sync_priority | sync_state 
-------+----------+----------+------------------+-------------+-----------------+-------------+---------------+--------------+-------+----------+-----------+-----------+------------+-----------+-----------+-
-----------+---------------+------------
 11205 |       10 | postgres | walreceiver      |             |                 |             |               |          559 |       |          |           |           |            |           |           | 
           |               | 
(1 row)
```
В логе на slave.  
```bash
2018-08-24 07:59:47 UTC [11223]: [2-1] user=,db=,app=,client= СООБЩЕНИЕ:  переход в режим резервного сервера
2018-08-24 07:59:47 UTC [11223]: [3-1] user=,db=,app=,client= СООБЩЕНИЕ:  запись REDO начинается со смещения 0/4000028
2018-08-24 07:59:47 UTC [11223]: [4-1] user=,db=,app=,client= СООБЩЕНИЕ:  согласованное состояние восстановления достигнуто по смещению 0/40000F8
2018-08-24 07:59:47 UTC [11219]: [7-1] user=,db=,app=,client= СООБЩЕНИЕ:  система БД готова к подключениям в режиме "только чтение"
2018-08-24 07:59:47 UTC [11227]: [1-1] user=,db=,app=,client= СООБЩЕНИЕ:  начало передачи журнала с главного сервера, с позиции 0/5000000 на линии времени 1
```

Для большей надёжности можно использовать [patroni](https://habr.com/post/322036/)

3 **Установить PostgresPro Standard, попробовать бекап и восстановление с помощью pg_probackup**  

Добавлен playbook в [bonus](https://github.com/YogSottot/otus_linux_1804/blob/master/4/27.PostgreSQL/bonus/provisioning/playbook.yml) разворачивающий postgres pro 10, инициализацирующий каталог резервных копий и создающий бэкап.  

```bash
[root@master backup]# cat /opt/backup/backups/otus/pg_probackup.conf 
#Backup instance info
PGDATA = /var/lib/pgpro/std-10/data
system-identifier = 6593222010354566721
#Connection parameters:
#Replica parameters:
replica-timeout = 5min
#Archive parameters:
archive-timeout = 5min
#Logging parameters:
log-level-console = INFO
log-level-file = OFF
log-filename = pg_probackup.log
log-directory = /opt/backup/log
log-rotation-size = 0KB
log-rotation-age = 0min
#Retention parameters:
retention-redundancy = 0
retention-window = 0
#Compression parameters:
compress-algorithm = none
compress-level = 1
```
```bash
/opt/pgpro/std-10/bin/pg_probackup backup -B /opt/backup/ --instance otus -b full --stream 
INFO: Backup start, pg_probackup version: 2.0.19, backup ID: PDYSU4, backup mode: full, instance: otus, stream: true, remote: false
INFO: wait for pg_stop_backup()
INFO: pg_stop backup() successfully executed
INFO: Validating backup PDYSU4
INFO: Backup PDYSU4 data files are valid
INFO: Backup PDYSU4 completed
```

Восстановление  
```bash
bash-4.2$ /opt/pgpro/std-10/bin/pg_probackup restore -B /opt/backup --instance otus
INFO: Validating backup PDYSU4
INFO: Backup PDYSU4 data files are valid
INFO: Backup PDYSU4 WAL segments are valid
INFO: Backup PDYSU4 is valid.
INFO: Restore of backup PDYSU4 completed.

```
