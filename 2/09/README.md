### Домашнее задание
#### разворачиваем сетевую лабораторию

##### Практическая часть
- Соединить офисы в сеть согласно схеме и настроить роутинг
- Все сервера и роутеры должны ходить в инет черз inetRouter
- Все сервера должны видеть друг друга
- у всех новых серверов отключить дефолт на нат (eth0), который вагрант поднимает для связи

Для начала создал схему сети. 
![schema](https://raw.githubusercontent.com/YogSottot/otus_linux_1804/master/2/09/Networkchart.svg?sanitize=true)
Нажмите, чтобы открыть в полном размере.

В vagrantfile задано создание сети по схеме.
Добавлены статические роуты.

```bash
[vagrant@inetRouter ~]$ ip r
192.168.255.0/30 dev eth1  proto kernel  scope link  src 192.168.255.1 
10.0.2.0/24 dev eth0  proto kernel  scope link  src 10.0.2.15 
169.254.0.0/16 dev eth0  scope link  metric 1002 
169.254.0.0/16 dev eth1  scope link  metric 1003 
192.168.0.0/16 via 192.168.255.2 dev eth1 
default via 10.0.2.2 dev eth0 

[vagrant@centralRouter ~]$ ip r
default via 192.168.255.1 dev eth1 proto static metric 100 
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100 
192.168.0.0/28 dev eth2 proto kernel scope link src 192.168.0.1 metric 100 
192.168.0.32/28 dev eth3 proto kernel scope link src 192.168.0.33 metric 100 
192.168.0.64/26 dev eth4 proto kernel scope link src 192.168.0.65 metric 100 
192.168.1.0/24 via 192.168.253.2 dev eth1 proto static metric 100 
192.168.2.0/24 via 192.168.254.2 dev eth1 proto static metric 100 
192.168.253.0/30 dev eth1 proto kernel scope link src 192.168.253.1 metric 100 
192.168.254.0/30 dev eth1 proto kernel scope link src 192.168.254.1 metric 100 
192.168.255.0/30 dev eth1 proto kernel scope link src 192.168.255.2 metric 100
```

Проверка того, что сервера из разных подсетей видят друг друга и имеют доступ в интернет.

```bash
[vagrant@centralServer ~]$ ping -c 4 192.168.1.2 ; ping -c 4 192.168.2.2 ; ping -c 4 ya.ru
PING 192.168.1.2 (192.168.1.2) 56(84) bytes of data.
64 bytes from 192.168.1.2: icmp_seq=1 ttl=62 time=2.06 ms
64 bytes from 192.168.1.2: icmp_seq=2 ttl=62 time=1.97 ms
64 bytes from 192.168.1.2: icmp_seq=3 ttl=62 time=1.88 ms
64 bytes from 192.168.1.2: icmp_seq=4 ttl=62 time=1.91 ms

--- 192.168.1.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 1.885/1.959/2.066/0.082 ms
PING 192.168.2.2 (192.168.2.2) 56(84) bytes of data.
64 bytes from 192.168.2.2: icmp_seq=1 ttl=62 time=1.96 ms
64 bytes from 192.168.2.2: icmp_seq=2 ttl=62 time=1.94 ms
64 bytes from 192.168.2.2: icmp_seq=3 ttl=62 time=1.94 ms
64 bytes from 192.168.2.2: icmp_seq=4 ttl=62 time=2.02 ms

--- 192.168.2.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 1.943/1.970/2.024/0.032 ms
PING ya.ru (87.250.250.242) 56(84) bytes of data.
64 bytes from ya.ru (87.250.250.242): icmp_seq=1 ttl=59 time=19.8 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=2 ttl=59 time=20.2 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=3 ttl=59 time=20.4 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=4 ttl=59 time=20.3 ms

--- ya.ru ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3008ms
rtt min/avg/max/mdev = 19.851/20.230/20.413/0.283 ms


[vagrant@office1Server ~]$ ping -c 4 192.168.1.2 ; ping -c 4 192.168.0.2 ; ping -c 4 ya.ru
PING 192.168.1.2 (192.168.1.2) 56(84) bytes of data.
64 bytes from 192.168.1.2: icmp_seq=1 ttl=61 time=2.07 ms
64 bytes from 192.168.1.2: icmp_seq=2 ttl=61 time=2.67 ms
64 bytes from 192.168.1.2: icmp_seq=3 ttl=61 time=2.56 ms
64 bytes from 192.168.1.2: icmp_seq=4 ttl=61 time=2.71 ms

--- 192.168.1.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3027ms
rtt min/avg/max/mdev = 2.078/2.506/2.716/0.256 ms
PING 192.168.0.2 (192.168.0.2) 56(84) bytes of data.
64 bytes from 192.168.0.2: icmp_seq=1 ttl=62 time=1.97 ms
64 bytes from 192.168.0.2: icmp_seq=2 ttl=62 time=1.85 ms
64 bytes from 192.168.0.2: icmp_seq=3 ttl=62 time=0.637 ms
64 bytes from 192.168.0.2: icmp_seq=4 ttl=62 time=2.03 ms

--- 192.168.0.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 0.637/1.626/2.039/0.577 ms
PING ya.ru (87.250.250.242) 56(84) bytes of data.
64 bytes from ya.ru (87.250.250.242): icmp_seq=1 ttl=57 time=21.2 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=2 ttl=57 time=19.3 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=3 ttl=57 time=20.9 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=4 ttl=57 time=21.1 ms

--- ya.ru ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3027ms
rtt min/avg/max/mdev = 19.303/20.667/21.239/0.793 ms


[vagrant@office2Server ~]$ ping -c 4 192.168.2.2 ; ping -c 4 192.168.0.2 ; ping -c 4 ya.ru
PING 192.168.2.2 (192.168.2.2) 56(84) bytes of data.
64 bytes from 192.168.2.2: icmp_seq=1 ttl=61 time=3.30 ms
64 bytes from 192.168.2.2: icmp_seq=2 ttl=61 time=2.65 ms
64 bytes from 192.168.2.2: icmp_seq=3 ttl=61 time=2.65 ms
64 bytes from 192.168.2.2: icmp_seq=4 ttl=61 time=2.56 ms

--- 192.168.2.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3021ms
rtt min/avg/max/mdev = 2.564/2.795/3.304/0.300 ms
PING 192.168.0.2 (192.168.0.2) 56(84) bytes of data.
64 bytes from 192.168.0.2: icmp_seq=1 ttl=62 time=1.94 ms
64 bytes from 192.168.0.2: icmp_seq=2 ttl=62 time=1.79 ms
64 bytes from 192.168.0.2: icmp_seq=3 ttl=62 time=1.99 ms
64 bytes from 192.168.0.2: icmp_seq=4 ttl=62 time=2.06 ms

--- 192.168.0.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3015ms
rtt min/avg/max/mdev = 1.797/1.950/2.067/0.099 ms
PING ya.ru (87.250.250.242) 56(84) bytes of data.
64 bytes from ya.ru (87.250.250.242): icmp_seq=1 ttl=57 time=21.0 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=2 ttl=57 time=21.0 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=3 ttl=57 time=20.8 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=4 ttl=57 time=21.4 ms

--- ya.ru ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3022ms
rtt min/avg/max/mdev = 20.869/21.117/21.455/0.277 ms
```


#####  Теоретическая часть
- Найти свободные подсети
- Посчитать сколько узлов в каждой подсети, включая свободные
- Указать broadcast адрес для каждой подсети


Используются сети

Сеть office1
- 192.168.2.0/26 - dev 

	```
	Broadcast: 192.168.2.63 
	HostMin:   192.168.2.1 
	HostMax:   192.168.2.62
	Hosts/Net: 62
	```

- 192.168.2.64/26 - test servers

	```
	Network:   192.168.2.64/26
	Broadcast: 192.168.2.127
	HostMin:   192.168.2.65
	HostMax:   192.168.2.126
	Hosts/Net: 62                  
	```

- 192.168.2.128/26 - managers

	```
	Network:   192.168.2.128/26 
	Broadcast: 192.168.2.191
	HostMin:   192.168.2.129 
	HostMax:   192.168.2.190
	Hosts/Net: 62     
	```

- 192.168.2.192/26 - office hardware

	```
	Network:   192.168.2.192/26
	Broadcast: 192.168.2.255
	HostMin:   192.168.2.193
	HostMax:   192.168.2.254
	Hosts/Net: 62
	```
В сети offcie1 больше нет свободных подсетей, так как вся 192.168.2.0/24 разбита на 4 подсети /26.
Суммарное возможное количество хостов 248

Сеть office2
- 192.168.1.0/25 - dev

	```
	Network:   192.168.1.0/25
	Broadcast: 192.168.1.127
	HostMin:   192.168.1.1
	HostMax:   192.168.1.126
	Hosts/Net: 126
	```

- 192.168.1.128/26 - test servers

	```
	Network:   192.168.1.128/26
	Broadcast: 192.168.1.191
	HostMin:   192.168.1.129
	HostMax:   192.168.1.190
	Hosts/Net: 62      
	```

- 192.168.1.192/26 - office hardware

	```
	Network:   192.168.1.192/26
	Broadcast: 192.168.1.255
	HostMin:   192.168.1.193
	HostMax:   192.168.1.254
	Hosts/Net: 62
	```
В сети offcie2 больше нет свободных подсетей, так как вся 192.168.1.0/24 разбита на 1 подсеть /25 и 2 подсети /26.
Суммарное возможное количество хостов 250

Сеть central
- 192.168.0.0/28 - directors

	```
	Network:   192.168.0.0/28
	Broadcast: 192.168.0.15
	HostMin:   192.168.0.1
	HostMax:   192.168.0.14
	Hosts/Net: 14
	```
	
- 192.168.0.32/28 - office hardware

	```
	Network:   192.168.0.32/28
	Broadcast: 192.168.0.47
	HostMin:   192.168.0.33
	HostMax:   192.168.0.46
	Hosts/Net: 14 
	```

- 192.168.0.64/26 - wifi

	```
	Network:   192.168.0.64/26
	Broadcast: 192.168.0.127
	HostMin:   192.168.0.65
	HostMax:   192.168.0.126
	Hosts/Net: 62
    ```
В сети central есть свободные подсети

```bash
    Network:   192.168.0.16/28
    Broadcast: 192.168.0.31
    HostMin:   192.168.0.17
    HostMax:   192.168.0.30
    Hosts/Net: 14
```

```bash
    Network:   192.168.0.48/28
    Broadcast: 192.168.0.63
    HostMin:   192.168.0.49
    HostMax:   192.168.0.62
    Hosts/Net: 14
```

```
    Network:   192.168.0.128/25
    Broadcast: 192.168.0.255
    HostMin:   192.168.0.129
    HostMax:   192.168.0.254
    Hosts/Net: 126
```
Суммарное возможное количество хостов 244


Также остаются свободными подсети.

```bash
    10.0.0.0/16 (Broadcast: 10.0.255.255 Hosts/Net: 65534)
    172.16.0.0/16 (Broadcast: 172.16.255.255 Hosts/Net: 65534)
    192.168.{3..252}.0/24 (Broadcast: 192.168.{3..252}.255 Hosts/Net: 254)
    192.168.253.4/30 (Broadcast: 192.168.253.7 Hosts/Net: 2)
    192.168.253.8/30
    192.168.253.12/30
    ...
    192.168.253.252/30
    192.168.254.4/30
    192.168.254.8/30
    192.168.254.12/30
    ...
    192.168.254.252/30
    192.168.255.4/30
    192.168.255.8/30
    192.168.255.12/30
    ...
    192.168.255.252/30
```
