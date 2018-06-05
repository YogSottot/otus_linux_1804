### Домашнее задание
#### VPN

1. Между двумя виртуалками поднять vpn в режимах
- tun
- tap
Прочуствовать разницу.

2. Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку

3. Самостоятельно изучить, поднять ocserv и подключиться с хоста к виртуалке 

Vagrantfile для каждой задачи лежит в соответствующей директории. (tun/tap/ras/ocserv)

Запускать нужно прямо оттуда.

Проверка связи с клиентом:
```bash
 ping -c 4 10.1.0.2
PING 10.1.0.2 (10.1.0.2) 56(84) bytes of data.
64 bytes from 10.1.0.2: icmp_seq=1 ttl=64 time=1.42 ms
64 bytes from 10.1.0.2: icmp_seq=2 ttl=64 time=1.23 ms
64 bytes from 10.1.0.2: icmp_seq=3 ttl=64 time=1.27 ms
64 bytes from 10.1.0.2: icmp_seq=4 ttl=64 time=1.43 ms

--- 10.1.0.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 1.230/1.339/1.432/0.097 ms
```
