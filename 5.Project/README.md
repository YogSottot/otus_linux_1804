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

2 web-сервера (синхронизация файлов сайта через lsyncd):  
- nginx  
- php-fpm  
- filebeat  
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

  
gluster volume info
 gluster volume set wordpress network.ping-timeout 5
