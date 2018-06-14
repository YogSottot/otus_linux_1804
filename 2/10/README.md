### Домашнее задание
#### строим бонды и вланы

в Office1 в тестовой подсети появляется сервера с доп интерфесами и адресами
во internal сети testLAN
- testClient1 - 10.10.10.254
- testClient2 - 10.10.10.254
- testServer1- 10.10.10.1
- testServer2- 10.10.10.1

равести вланами
testClient1 <-> testServer1
testClient2 <-> testServer2

между centralRouter и inetRouter
"пробросить" 2 линка (2 internal сети) и объединить их в бонд актив-актив
проверить работу если выборать интерфейсы в бонде по очереди

Для начала создал схему сети. 
![schema](https://raw.githubusercontent.com/YogSottot/otus_linux_1804/master/2/10/Networkchart_bond.svg?sanitize=true)
Нажмите, чтобы открыть в полном размере.

В vagrantfile задано создание сети по схеме. (Закомментированы узлы не относящиеся к задаче.)



```bash
cat /proc/net/bonding/bond0 
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: fault-tolerance (active-backup) (fail_over_mac active)
Primary Slave: eth1 (primary_reselect always)
Currently Active Slave: eth1
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 200
Down Delay (ms): 200

Slave Interface: eth1
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 08:00:27:99:e7:e7
Slave queue ID: 0

Slave Interface: eth2
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 08:00:27:d1:fc:5b
Slave queue ID: 0
```

При ifdown eth1
```bash
cat /proc/net/bonding/bond0 
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: fault-tolerance (active-backup) (fail_over_mac active)
Primary Slave: None
Currently Active Slave: eth2
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 200
Down Delay (ms): 200

Slave Interface: eth2
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 08:00:27:d1:fc:5b
Slave queue ID: 0
```

Тестовый пинг
```bash
[vagrant@inetRouter ~]$ ping -c 4 192.168.255.2
PING 192.168.255.2 (192.168.255.2) 56(84) bytes of data.
64 bytes from 192.168.255.2: icmp_seq=1 ttl=64 time=1.12 ms
64 bytes from 192.168.255.2: icmp_seq=2 ttl=64 time=0.693 ms
64 bytes from 192.168.255.2: icmp_seq=3 ttl=64 time=0.719 ms
64 bytes from 192.168.255.2: icmp_seq=4 ttl=64 time=0.701 ms

--- 192.168.255.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 0.693/0.810/1.128/0.184 ms
```

Отключаем eth1, и повторяем пинг.
```bash
[root@centralRouter vagrant]# ifdown eth1
Device 'eth1' successfully disconnected.

[vagrant@inetRouter ~]$ ping -c 4 192.168.255.2
PING 192.168.255.2 (192.168.255.2) 56(84) bytes of data.
64 bytes from 192.168.255.2: icmp_seq=1 ttl=64 time=0.783 ms
64 bytes from 192.168.255.2: icmp_seq=2 ttl=64 time=1.25 ms
64 bytes from 192.168.255.2: icmp_seq=3 ttl=64 time=0.697 ms
64 bytes from 192.168.255.2: icmp_seq=4 ttl=64 time=0.701 ms

--- 192.168.255.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3007ms
rtt min/avg/max/mdev = 0.697/0.859/1.255/0.231 ms
```

Если eth1 и eth2 размещены в разных internal сетях virtualbox, то пинг не проходит, при отключении eth1
Если eth1 и eth2 размещены в одной internal сети virtualbox, то пинг проходит, при отключении eth1

C клиента testClient1/2 можно попасть ssh на сервер testServer1/2 без пароля.
```bash
[vagrant@testClient1 ~]$ ssh 10.10.10.1
[vagrant@testServer1 ~]$ 

[vagrant@testServer1 ~]$ ping -c 4 10.10.10.254
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=0.692 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=0.682 ms
64 bytes from 10.10.10.254: icmp_seq=3 ttl=64 time=0.601 ms
64 bytes from 10.10.10.254: icmp_seq=4 ttl=64 time=0.689 ms

--- 10.10.10.254 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 0.601/0.666/0.692/0.037 ms
[vagrant@testServer1 ~]$ 

[vagrant@testClient2 ~]$ ssh 10.10.10.1
The authenticity of host '10.10.10.1 (10.10.10.1)' can't be established.
ECDSA key fingerprint is SHA256:vLZN+zPwe9N6GXVuTdtaPHuWcELA1DQ8/Qm32jsAwwA.
ECDSA key fingerprint is MD5:be:b7:bb:ae:71:e8:f8:3b:34:57:7c:d1:48:17:9c:c6.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '10.10.10.1' (ECDSA) to the list of known hosts.
[vagrant@testServer2 ~]$

[vagrant@testServer2 ~]$ ping -c 4 10.10.10.254
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=0.550 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=0.412 ms
64 bytes from 10.10.10.254: icmp_seq=3 ttl=64 time=0.757 ms
64 bytes from 10.10.10.254: icmp_seq=4 ttl=64 time=0.611 ms

--- 10.10.10.254 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3002ms
rtt min/avg/max/mdev = 0.412/0.582/0.757/0.126 ms
```
