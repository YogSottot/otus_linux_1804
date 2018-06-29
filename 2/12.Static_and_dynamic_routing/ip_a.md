```bash
[root@testServer1 vagrant]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet 10.1.0.1/24 brd 10.1.0.255 scope global lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:5f:94:78 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 80250sec preferred_lft 80250sec
    inet6 fe80::5054:ff:fe5f:9478/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:2d:ce:75 brd ff:ff:ff:ff:ff:ff
    inet 172.16.12.1/30 brd 172.16.12.3 scope global eth1
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:ab:5e:24 brd ff:ff:ff:ff:ff:ff
    inet 172.16.12.5/30 brd 172.16.12.7 scope global eth2
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feab:5e24/64 scope link 
       valid_lft forever preferred_lft forever

```

```bash
[root@testServer2 vagrant]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet 10.2.0.1/24 brd 10.2.0.255 scope global lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:5f:94:78 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 78785sec preferred_lft 78785sec
    inet6 fe80::5054:ff:fe5f:9478/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:7a:f3:e4 brd ff:ff:ff:ff:ff:ff
    inet 172.16.12.6/30 brd 172.16.12.7 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe7a:f3e4/64 scope link 
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:28:4e:bb brd ff:ff:ff:ff:ff:ff
    inet 172.16.12.9/30 brd 172.16.12.11 scope global eth2
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe28:4ebb/64 scope link 
       valid_lft forever preferred_lft forever

```

```bash
[root@testServer3 vagrant]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet 10.3.0.1/24 brd 10.3.0.255 scope global lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:5f:94:78 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 81570sec preferred_lft 81570sec
    inet6 fe80::5054:ff:fe5f:9478/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:55:f6:76 brd ff:ff:ff:ff:ff:ff
    inet 172.16.12.2/30 brd 172.16.12.3 scope global eth1
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:55:3a:50 brd ff:ff:ff:ff:ff:ff
    inet 172.16.12.10/30 brd 172.16.12.11 scope global eth2
       valid_lft forever preferred_lft forever

```
