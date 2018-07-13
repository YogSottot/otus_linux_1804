### Домашнее задание
#### первые шаги с ансибл

**Переделать разворачивание файрволла (ДЗ 14) а через ansible**  
- в рамках ДЗ создать свою роль **  

Переписано. Созданы роли: nginx, ip_forwarding, disable_defroute_vagrant, ssh-server, ssh-client.

1 **реализовать knocking port**  

knock_full.sh запускать только под root.
```bash
[root@centralRouter vagrant]# /vagrant/provisioning/knock_full.sh 
ssh: connect to host 192.168.255.1 port 22: Connection refused

Starting Nmap 6.40 ( http://nmap.org ) at 2018-07-13 13:27 UTC
Warning: 192.168.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 192.168.255.1
Host is up (0.00021s latency).
PORT     STATE    SERVICE
8991/tcp filtered unknown
MAC Address: 08:00:27:35:88:F0 (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 0.17 seconds

Starting Nmap 6.40 ( http://nmap.org ) at 2018-07-13 13:27 UTC
Warning: 192.168.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 192.168.255.1
Host is up (0.00025s latency).
PORT     STATE    SERVICE
7766/tcp filtered unknown
MAC Address: 08:00:27:35:88:F0 (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 0.17 seconds

Starting Nmap 6.40 ( http://nmap.org ) at 2018-07-13 13:27 UTC
Warning: 192.168.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 192.168.255.1
Host is up (0.00023s latency).
PORT     STATE    SERVICE
5591/tcp filtered unknown
MAC Address: 08:00:27:35:88:F0 (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 0.18 seconds
The authenticity of host '192.168.255.1 (192.168.255.1)' can't be established.
RSA key fingerprint is SHA256:mLWmfFIlfnuFLiUjUUIzNuyTocAX4bteokFv+zGhzy4.
RSA key fingerprint is MD5:d2:51:bb:cc:3a:96:53:0b:9f:05:ea:ea:b3:8c:b8:9c.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.255.1' (RSA) to the list of known hosts.
Last login: Fri Jul 13 12:54:18 2018 from 10.0.2.2
[vagrant@inetRouter ~]$ exit
logout
Connection to 192.168.255.1 closed.
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
