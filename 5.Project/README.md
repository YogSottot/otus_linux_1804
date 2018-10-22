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
- Galera Arbitrator (следит за состоянием кластера БД на db1 / db2)  (Необходим для избежания split-brain, так как у нас только два узла БД)

2 web-сервера (синхронизация файлов сайта через lsyncd):  
- nginx  
- php-fpm  
- ProxySQL - вместо HAProxy для db?

2 сервера БД:
- Percona XtraDB Cluster (Master-Master)

1 сервер для логирования и бэкапов
- elk
- sftp

https://github.com/hanru/ansible-lsyncd
https://github.com/leucos/ansible-lsyncd-fanout
https://github.com/lchabert/ansible-lsyncd
https://github.com/ccremer/ansible-lsyncd
