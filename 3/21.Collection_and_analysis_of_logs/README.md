### Домашнее задание
#### Настраиваем центральный сервер для сбора логов

1 **в вагранте поднимаем 2 машины web и log**  

- на web поднимаем nginx  
  - на log настраиваем центральный лог сервер на любой системе на выбор  
  - journald  
  - rsyslog  
  - elk  

Выбран rsyslog.  

- настраиваем аудит следящий за изменением конфигов нжинкса  

```bash
cat /etc/audit/rules.d/audit.rules
## nginx configurations
-w /etc/nginx/ -p wa -k nginx
```
```bash
type=EXECVE msg=audit(1532512884.579:3560): argc=2 a0="nano" a1="/etc/nginx/fastcgi_params"
type=SYSCALL msg=audit(1532512884.582:3561): arch=c000003e syscall=2 success=yes exit=3 a0=20f7510 a1=441 a2=1b6 a3=63 items=2 ppid=10489 pid=20239 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=6 comm="nano" exe="/usr/bin/nano" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="nginx"
type=PATH msg=audit(1532512884.582:3561): item=0 name="/etc/nginx/" inode=33554530 dev=fd:00 mode=040755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=PARENT
type=PATH msg=audit(1532512884.582:3561): item=1 name="/etc/nginx/fastcgi_params" inode=33826723 dev=fd:00 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=NORMAL
type=SYSCALL msg=audit(1532512894.730:3562): arch=c000003e syscall=2 success=yes exit=3 a0=20fb990 a1=241 a2=1b6 a3=7ffdf0c9f370 items=2 ppid=10489 pid=20239 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=6 comm="nano" exe="/usr/bin/nano" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="nginx"
type=PATH msg=audit(1532512894.730:3562): item=0 name="/etc/nginx/" inode=33554530 dev=fd:00 mode=040755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=PARENT
type=PATH msg=audit(1532512894.730:3562): item=1 name="/etc/nginx/fastcgi_params" inode=33826723 dev=fd:00 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=NORMAL
type=EXECVE msg=audit(1532512904.010:3575): argc=4 a0="grep" a1="--color=auto" a2="nginx" a3="/var/log/audit/audit.log"

```

- все критичные логи с web должны собираться и локально и удаленно  

```bash

if $syslogseverity-text == "crit" then {
        action(type="omfwd"
                Target="192.168.1.1"
                Port="514"
                Protocol="udp")
		action(type="omfile"
                File="/var/log/crit.log")
}

```

- все логи с nginx должны уходить на удаленный сервер (локально только критичные)  

В конфиг nginx.
```bash
access_log syslog:server=192.168.1.1,facility=local7,tag=nginx_acess,severity=info;
error_log syslog:server=192.168.1.1,facility=local7,tag=nginx_error,severity=info;
error_log /var/log/nginx/error.log crit;
```
- логи аудита уходят ТОЛЬКО на удаленную систему  

```bash
# в syslog.conf
args = LOG_INFO LOG_LOCAL6

# в rsyslog.conf
*.info;mail.none;authpriv.none;cron.none;local6.none                /var/log/messages

if $programname == "audispd" then {
        action(type="omfwd"
                Target="192.168.1.1"
                Port="514"
                Protocol="udp")
}

```

2 **развернуть еще машину elk**  

```bash
кластер ElasticSearch из одной ноды.
index.number_of_shards: 1
index.number_of_replicas: 0
node.local: true
discovery.zen.ping.multicast.enabled: false
discovery.zen.minimum_master_nodes: 1
node.max_local_storage_nodes: 1
```

- и таким образом настроить 2 центральных лог системы elk И какую либо еще  

В первой задаче создан один лог-сервер (rsyslog). Во второй задаче создан elk-сервер. Таким образом всего 2 лог-сервера.

- в elk должны уходить только логи нжинкса  
```bash
# rsyslog Templates
template(name="ElasticSearchTemplate"
type="list"
option.json="on") {
constant(value="{")
 constant(value="\"timestamp\":\"")      property(name="timereported" dateFormat="rfc3339")
 constant(value="\",\"message\":\"")     property(name="msg")
 constant(value="\",\"host\":\"")        property(name="hostname")
 constant(value="\",\"severity\":\"")    property(name="syslogseverity-text")
 constant(value="\",\"facility\":\"")    property(name="syslogfacility-text")
 constant(value="\",\"syslogtag\":\"")   property(name="syslogtag")
constant(value="\"}")
}

# rsyslog Input Modules
module(load="omelasticsearch")

# rsyslog RuleSets
if $programname == "nginx_access" or if $programname == "nginx_error" then {
	action(type="omelasticsearch" 
	 	server="192.168.255.5"
	 	serverport="9200"
	 	searchIndex="nginx-index"
	 	searchType="nginx-log"
	 	bulkmode="1"
	 	template="template(name="ElasticSearchTemplate"
type="list"
option.json="on") {
constant(value="{")
 constant(value="\"timestamp\":\"")      property(name="timereported" dateFormat="rfc3339")
 constant(value="\",\"message\":\"")     property(name="msg")
 constant(value="\",\"host\":\"")        property(name="hostname")
 constant(value="\",\"severity\":\"")    property(name="syslogseverity-text")
 constant(value="\",\"facility\":\"")    property(name="syslogfacility-text")
 constant(value="\",\"syslogtag\":\"")   property(name="syslogtag")
constant(value="\"}")
}")
}
```
- во вторую систему все остальное  

Настройки из пункта 1.  
