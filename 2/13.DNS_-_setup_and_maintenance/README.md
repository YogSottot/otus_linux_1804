### DNS - настройка и обслуживание
#### настраиваем split-dns
взять стенд https://github.com/erlong15/vagrant-bind

***добавить еще один сервер client2***

Добавлен в ansible и vagrantfile  
***завести в зоне dns.lab***  
имена  
web1 — смотрит на клиент1  
web2 — смотрит на клиент2  

```
web1            IN      A       192.168.50.15
web2            IN      A       192.168.50.16
```

завести еще одну зону newdns.lab  
завести в ней запись  
www - смотрит на обоих клиентов  

```
$TTL 3600
$ORIGIN newdns.lab.
@               IN      SOA     ns01.newdns.lab. root.newdns.lab. (
                            2711201409 ; serial
                            3600       ; refresh (1 hour)
                            600        ; retry (10 minutes)
                            86400      ; expire (1 day)
                            600        ; minimum (10 minutes)
                        )

                IN      NS      ns01.newdns.lab.
                IN      NS      ns02.newdns.lab.

; DNS Servers
ns01            IN      A       192.168.50.10
ns02            IN      A       192.168.50.11
www            IN      A       192.168.50.15
www            IN      A       192.168.50.16
```

***настроить split-dns***  
Использованы views  
клиент1 - видит обе зоны, но в зоне dns.lab только web1  

```bash
[root@client1 vagrant]# ping -c 4 web1
PING web1.dns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from client1 (192.168.50.15): icmp_seq=1 ttl=64 time=0.030 ms
64 bytes from client1 (192.168.50.15): icmp_seq=2 ttl=64 time=0.055 ms
64 bytes from client1 (192.168.50.15): icmp_seq=3 ttl=64 time=0.023 ms
64 bytes from client1 (192.168.50.15): icmp_seq=4 ttl=64 time=0.055 ms

--- web1.dns.lab ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3001ms
rtt min/avg/max/mdev = 0.023/0.040/0.055/0.016 ms

[root@client1 vagrant]# ping -c 4 web2
ping: web2: Name or service not known

[root@client1 vagrant]# ping -c 4 www.newdns.lab
PING www.newdns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from client1 (192.168.50.15): icmp_seq=1 ttl=64 time=0.032 ms
64 bytes from client1 (192.168.50.15): icmp_seq=2 ttl=64 time=0.053 ms
64 bytes from client1 (192.168.50.15): icmp_seq=3 ttl=64 time=0.054 ms
64 bytes from client1 (192.168.50.15): icmp_seq=4 ttl=64 time=0.054 ms

--- www.newdns.lab ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3018ms
rtt min/avg/max/mdev = 0.032/0.048/0.054/0.010 ms
```

клиент2 видит только dns.lab  
```bash
[vagrant@client2 ~]$ ping -c 4 web1
PING web1.dns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=1 ttl=64 time=0.188 ms
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=2 ttl=64 time=0.694 ms
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=3 ttl=64 time=0.668 ms
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=4 ttl=64 time=0.635 ms

--- web1.dns.lab ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3025ms
rtt min/avg/max/mdev = 0.188/0.546/0.694/0.208 ms
[vagrant@client2 ~]$ ping -c 4 web2
PING web2.dns.lab (192.168.50.16) 56(84) bytes of data.
64 bytes from client2 (192.168.50.16): icmp_seq=1 ttl=64 time=0.011 ms
64 bytes from client2 (192.168.50.16): icmp_seq=2 ttl=64 time=0.053 ms
64 bytes from client2 (192.168.50.16): icmp_seq=3 ttl=64 time=0.053 ms
64 bytes from client2 (192.168.50.16): icmp_seq=4 ttl=64 time=0.052 ms

--- web2.dns.lab ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 0.011/0.042/0.053/0.018 ms
[vagrant@client2 ~]$ ping -c 4 www.newdns.lab
ping: www.newdns.lab: Name or service not known
[vagrant@client2 ~]$ 
```

*) настроить все без выключения selinux  
ddns тоже должен работать без выключения selinux  

В playbook добавлены команды для настройки selinux  

```bash
[root@client1 vagrant]# nsupdate -k /etc/named.zonetransfer.key
> server 192.168.50.10
> zone ddns.lab
> update add www.ddns.lab. 60 A 192.168.50.15
> send
> quit

[root@client1 vagrant]# ping -c 2 www.ddns.lab
PING www.ddns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from client1 (192.168.50.15): icmp_seq=1 ttl=64 time=0.060 ms
64 bytes from client1 (192.168.50.15): icmp_seq=2 ttl=64 time=0.055 ms

--- www.ddns.lab ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1010ms
rtt min/avg/max/mdev = 0.055/0.057/0.060/0.008 ms

```
