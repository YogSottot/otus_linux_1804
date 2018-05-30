### Домашнее задание
#### разворачиваем сетевую лабораторию


[vagrant@inetRouter ~]$ ip r
192.168.255.0/30 dev eth1  proto kernel  scope link  src 192.168.255.1 
10.0.2.0/24 dev eth0  proto kernel  scope link  src 10.0.2.15 
169.254.0.0/16 dev eth0  scope link  metric 1002 
169.254.0.0/16 dev eth1  scope link  metric 1003 
192.168.0.0/16 via 192.168.255.2 dev eth1 
default via 10.0.2.2 dev eth0 


[vagrant@inetRouter ~]$ traceroute 192.168.2.2
traceroute to 192.168.2.2 (192.168.2.2), 30 hops max, 60 byte packets
 1  192.168.255.2 (192.168.255.2)  0.667 ms  0.414 ms  0.463 ms
 2  192.168.254.2 (192.168.254.2)  0.951 ms  0.736 ms  0.842 ms
 3  192.168.2.2 (192.168.2.2)  3.551 ms  3.821 ms  3.565 ms


[vagrant@inetRouter ~]$ traceroute 192.168.1.2
traceroute to 192.168.1.2 (192.168.1.2), 30 hops max, 60 byte packets
 1  192.168.255.2 (192.168.255.2)  0.711 ms  0.380 ms  0.365 ms
 2  192.168.253.2 (192.168.253.2)  0.999 ms  0.791 ms  0.910 ms
 3  192.168.1.2 (192.168.1.2)  1.995 ms  1.821 ms  2.144 ms

[vagrant@inetRouter ~]$ traceroute 192.168.0.2
traceroute to 192.168.0.2 (192.168.0.2), 30 hops max, 60 byte packets
 1  192.168.255.2 (192.168.255.2)  0.676 ms  0.341 ms  0.471 ms
 2  192.168.0.2 (192.168.0.2)  0.812 ms  0.556 ms  0.717 ms




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

