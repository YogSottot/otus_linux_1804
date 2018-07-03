### Домашнее задание
#### Сценарии iptables

Для начала создал схему сети. 
![schema](https://raw.githubusercontent.com/YogSottot/otus_linux_1804/master/2/14.Traffic_filtering/Networkchart_firewall.svg?sanitize=true)
Нажмите, чтобы открыть в полном размере.

В vagrantfile задано создание сети по схеме.

1 **реализовать knocking port**  
- centralRouter может попасть на ssh inetrRouter через knock скрипт  
пример в материалах  

Реализован доступ по ключу.
```bash
[root@centralRouter vagrant]# bash /vagrant/provisioning/knock_full.sh 
# отказ в соединении
ssh: connect to host 192.168.255.1 port 22: Connection refused

# knocking
Starting Nmap 6.40 ( http://nmap.org ) at 2018-07-03 11:34 UTC
Warning: 192.168.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 192.168.255.1
Host is up (0.00028s latency).
PORT     STATE    SERVICE
8991/tcp filtered unknown
MAC Address: 08:00:27:C3:F9:3C (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 0.17 seconds

Starting Nmap 6.40 ( http://nmap.org ) at 2018-07-03 11:34 UTC
Warning: 192.168.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 192.168.255.1
Host is up (0.00025s latency).
PORT     STATE    SERVICE
7766/tcp filtered unknown
MAC Address: 08:00:27:C3:F9:3C (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 0.17 seconds

Starting Nmap 6.40 ( http://nmap.org ) at 2018-07-03 11:34 UTC
Warning: 192.168.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 192.168.255.1
Host is up (0.00026s latency).
PORT     STATE    SERVICE
5591/tcp filtered unknown
MAC Address: 08:00:27:C3:F9:3C (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 0.17 seconds

# соединение принято после knocking
Last login: Tue Jul  3 11:31:44 2018 from 192.168.255.2
[vagrant@inetRouter ~]$ 
```

2 **добавить inetRouter2, который виден(маршрутизируется) с хоста**  
Добавлен через vagrantfile  
Публичный ip 192.168.0.254 — следует поменять, если локалка на хосте имеет другую сеть.  

3 **запустить nginx на centralServer**  
Запущен  
4 **пробросить 80й порт на inetRouter2 8080**  
Проброшен  
![nginx](https://i.imgur.com/Kl0Uz0s.png)

5 **дефолт в инет оставить через inetRouter**  

Оставлен.  
Пинг в интернет идёт через inetRouter (192.168.255.1)
```bash
[vagrant@centralServer ~]$ tracepath ya.ru
 1?: [LOCALHOST]                                         pmtu 1500
 1:  gateway                                               1.026ms 
 1:  gateway                                               1.084ms 
 2:  192.168.255.1                                         1.610ms 
 3:  10.0.2.2                                              2.125ms 
```
