### Домашнее задание
#### Статическая и динамическая маршрутизация


- Подняты три виртуалки
- Объединены разными vlan

Присылаем
- вывод ip a
- конфиги /etc/quagga/*
- вывод tracepath для каждого из трёх случаев 

Для начала создал схему сети. 
![schema](https://raw.githubusercontent.com/YogSottot/otus_linux_1804/master/2/12%20Static%20and%20dynamic%20routing/Networkchart_quagga.xml?sanitize=true)
Нажмите, чтобы открыть в полном размере.

В vagrantfile задано создание сети по схеме.

1. *Поднять OSPF между машинами на базе Quagga*

Вывод ip a  ![в файле](https://github.com/YogSottot/otus_linux_1804/blob/master/2/12%20Static%20and%20dynamic%20routing/ip_a.md)

```bash
testServer1# show ip ospf
 OSPF Routing Process, Router ID: 10.1.0.1
 Supports only single TOS (TOS0) routes
 This implementation conforms to RFC2328
 RFC1583Compatibility flag is disabled
 OpaqueCapability flag is disabled
 Initial SPF scheduling delay 200 millisec(s)
 Minimum hold time between consecutive SPFs 1000 millisec(s)
 Maximum hold time between consecutive SPFs 10000 millisec(s)
 Hold time multiplier is currently 1
 SPF algorithm last executed 17m07s ago
 SPF timer is inactive
 Refresh timer 10 secs
 This router is an ABR, ABR type is: Alternative Cisco
 Number of external LSA 0. Checksum Sum 0x00000000
 Number of opaque AS LSA 0. Checksum Sum 0x00000000
 Number of areas attached to this router: 2

 Area ID: 0.0.0.0 (Backbone)
   Number of interfaces in this area: Total: 2, Active: 2
   Number of fully adjacent neighbors in this area: 2
   Area has no authentication
   SPF algorithm executed 6 times
   Number of LSA 9
   Number of router LSA 3. Checksum Sum 0x0001baca
   Number of network LSA 3. Checksum Sum 0x00023cfb
   Number of summary LSA 3. Checksum Sum 0x00022d7b
   Number of ASBR summary LSA 0. Checksum Sum 0x00000000
   Number of NSSA LSA 0. Checksum Sum 0x00000000
   Number of opaque link LSA 0. Checksum Sum 0x00000000
   Number of opaque area LSA 0. Checksum Sum 0x00000000

 Area ID: 0.0.0.1
   Shortcutting mode: Default, S-bit consensus: ok
   Number of interfaces in this area: Total: 1, Active: 1
   Number of fully adjacent neighbors in this area: 0
   Area has no authentication
   Number of full virtual adjacencies going through this area: 0
   SPF algorithm executed 6 times
   Number of LSA 6
   Number of router LSA 1. Checksum Sum 0x0000d54c
   Number of network LSA 0. Checksum Sum 0x00000000
   Number of summary LSA 5. Checksum Sum 0x000109c0
   Number of ASBR summary LSA 0. Checksum Sum 0x00000000
   Number of NSSA LSA 0. Checksum Sum 0x00000000
   Number of opaque link LSA 0. Checksum Sum 0x00000000
   Number of opaque area LSA 0. Checksum Sum 0x00000000

```
```bash
testServer1# show ip route
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, A - Babel,
       > - selected route, * - FIB route

C>* 10.0.2.0/24 is directly connected, eth0
C>* 10.1.0.0/24 is directly connected, lo
O>* 10.1.0.1/32 [110/10] is directly connected, lo, 00:24:27
O>* 10.2.0.1/32 [110/20] via 172.16.12.6, eth2, 00:22:02
O>* 10.3.0.1/32 [110/20] via 172.16.12.2, eth1, 00:19:39
C>* 127.0.0.0/8 is directly connected, lo
O   172.16.12.0/30 [110/10] is directly connected, eth1, 00:24:27
C>* 172.16.12.0/30 is directly connected, eth1
O   172.16.12.4/30 [110/10] is directly connected, eth2, 00:24:27
C>* 172.16.12.4/30 is directly connected, eth2
O>* 172.16.12.8/30 [110/20] via 172.16.12.2, eth1, 00:19:39
  *                         via 172.16.12.6, eth2, 00:19:39

```
```bash
show ip ospf neighbor

    Neighbor ID Pri State           Dead Time Address         Interface            RXmtL RqstL DBsmL
10.3.0.1          1 Full/Backup       56.628s 172.16.12.2     eth1:172.16.12.1         0     0     0
10.2.0.1          1 Full/Backup       41.788s 172.16.12.6     eth2:172.16.12.5         0     0     0
```
```bash
 sh ip ospf interface 
eth0 is up
  ifindex 2, MTU 1500 bytes, BW 0 Kbit <UP,BROADCAST,RUNNING,MULTICAST>
  OSPF not enabled on this interface
eth1 is up
  ifindex 3, MTU 1500 bytes, BW 0 Kbit <UP,BROADCAST,RUNNING,MULTICAST>
  Internet Address 172.16.12.1/30, Broadcast 172.16.12.3, Area 0.0.0.0
  MTU mismatch detection:enabled
  Router ID 10.1.0.1, Network Type BROADCAST, Cost: 10
  Transmit Delay is 1 sec, State DR, Priority 1
  Designated Router (ID) 10.1.0.1, Interface Address 172.16.12.1
  Backup Designated Router (ID) 10.3.0.1, Interface Address 172.16.12.2
  Multicast group memberships: OSPFAllRouters OSPFDesignatedRouters
  Timer intervals configured, Hello 20s, Dead 60s, Wait 60s, Retransmit 5
    Hello due in 17.341s
  Neighbor Count is 1, Adjacent neighbor count is 1
eth2 is up
  ifindex 4, MTU 1500 bytes, BW 0 Kbit <UP,BROADCAST,RUNNING,MULTICAST>
  Internet Address 172.16.12.5/30, Broadcast 172.16.12.7, Area 0.0.0.0
  MTU mismatch detection:enabled
  Router ID 10.1.0.1, Network Type BROADCAST, Cost: 10
  Transmit Delay is 1 sec, State DR, Priority 1
  Designated Router (ID) 10.1.0.1, Interface Address 172.16.12.5
  Backup Designated Router (ID) 10.2.0.1, Interface Address 172.16.12.6
  Multicast group memberships: OSPFAllRouters OSPFDesignatedRouters
  Timer intervals configured, Hello 20s, Dead 60s, Wait 60s, Retransmit 5
    Hello due in 17.341s
  Neighbor Count is 1, Adjacent neighbor count is 1
lo is up
  ifindex 1, MTU 65536 bytes, BW 0 Kbit <UP,LOOPBACK,RUNNING>
  Internet Address 10.1.0.1/24, Broadcast 10.1.0.255, Area 0.0.0.1
  MTU mismatch detection:enabled
  Router ID 10.1.0.1, Network Type LOOPBACK, Cost: 10
  Transmit Delay is 1 sec, State Loopback, Priority 1
  No designated router on this network
  No backup designated router on this network
  Multicast group memberships: <None>
  Timer intervals configured, Hello 20s, Dead 60s, Wait 60s, Retransmit 5
    Hello due in inactive
  Neighbor Count is 0, Adjacent neighbor count is 0
```
```bash
[root@testServer1 vagrant]# vtysh -c 'show ip route 172.16.12.0/30'
Routing entry for 172.16.12.0/30
  Known via "ospf", distance 110, metric 10
  Last update 00:10:46 ago
    directly connected, eth1

Routing entry for 172.16.12.0/30
  Known via "connected", distance 0, metric 1, best
  * directly connected, eth1

[root@testServer1 vagrant]# vtysh -c 'show ip route 172.16.12.4/30'
Routing entry for 172.16.12.4/30
  Known via "ospf", distance 110, metric 10
  Last update 01:04:33 ago
    directly connected, eth2

Routing entry for 172.16.12.4/30
  Known via "connected", distance 0, metric 1, best
  * directly connected, eth2

[root@testServer1 vagrant]# vtysh -c 'show ip route 172.16.12.8/30'
Routing entry for 172.16.12.8/30
  Known via "ospf", distance 110, metric 20, best
  Last update 00:12:19 ago
  * 172.16.12.2, via eth1
  * 172.16.12.6, via eth2

```

Вывод tracepath

```bash
[root@testServer1 vagrant]# tracepath 172.16.12.2
 1?: [LOCALHOST]                                         pmtu 1500
 1:  172.16.12.2                                           0.959ms reached
 1:  172.16.12.2                                           1.173ms reached
     Resume: pmtu 1500 hops 1 back 1 
     
[root@testServer1 vagrant]# tracepath 172.16.12.10
 1?: [LOCALHOST]                                         pmtu 1500
 1:  172.16.12.10                                          1.024ms reached
 1:  172.16.12.10                                          1.209ms reached
     Resume: pmtu 1500 hops 1 back 1 
     
[root@testServer1 vagrant]# tracepath 172.16.12.6
 1?: [LOCALHOST]                                         pmtu 1500
 1:  172.16.12.6                                           1.306ms reached
 1:  172.16.12.6                                           0.487ms reached
     Resume: pmtu 1500 hops 1 back 1 
     
[root@testServer1 vagrant]# tracepath 172.16.12.9
 1?: [LOCALHOST]                                         pmtu 1500
 1:  172.16.12.9                                           0.635ms reached
 1:  172.16.12.9                                           0.367ms reached
     Resume: pmtu 1500 hops 1 back 1 


[root@testServer1 vagrant]# tracepath 10.2.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.2.0.1                                              0.963ms reached
 1:  10.2.0.1                                              1.281ms reached
     Resume: pmtu 1500 hops 1 back 1 
[root@testServer1 vagrant]# tracepath 10.3.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.3.0.1                                              1.000ms reached
 1:  10.3.0.1                                              1.150ms reached
     Resume: pmtu 1500 hops 1 back 1
     
```

Конфиги /etc/quagga/ в директории quagga

2. Изобразить асимметричный роутинг

Вывод tracepath

```bash

     
```

3. Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным

```bash
testServer1# configure  terminal 
testServer1(config)# interface  eth1
testServer1(config-if)# ospf cost 1000

```
```bash
testServer1# sh ip ospf interface eth1
eth1 is up
  ifindex 3, MTU 1500 bytes, BW 0 Kbit <UP,BROADCAST,RUNNING,MULTICAST>
  Internet Address 172.16.12.1/30, Broadcast 172.16.12.3, Area 0.0.0.0
  MTU mismatch detection:enabled
  Router ID 10.1.0.1, Network Type BROADCAST, Cost: 1000
  Transmit Delay is 1 sec, State DR, Priority 1
  Designated Router (ID) 10.1.0.1, Interface Address 172.16.12.1
  Backup Designated Router (ID) 10.3.0.1, Interface Address 172.16.12.2
  Saved Network-LSA sequence number 0x80000002
  Multicast group memberships: OSPFAllRouters OSPFDesignatedRouters
  Timer intervals configured, Hello 20s, Dead 60s, Wait 60s, Retransmit 5
    Hello due in 6.161s
  Neighbor Count is 1, Adjacent neighbor count is 1

```

```bash
[root@testServer1 vagrant]# vtysh -c 'show ip route 172.16.12.8/30'
Routing entry for 172.16.12.8/30
  Known via "ospf", distance 110, metric 20, best
  Last update 00:00:15 ago
  * 172.16.12.6, via eth2
```

Вывод tracepath

```bash
[root@testServer1 vagrant]# tracepath 172.16.12.10
 1?: [LOCALHOST]                                         pmtu 1500
 1:  172.16.12.6                                           1.083ms 
 1:  172.16.12.6                                           1.481ms 
 2:  172.16.12.10                                          1.797ms reached
     Resume: pmtu 1500 hops 2 back 2 

[root@testServer1 vagrant]# tracepath 172.16.12.2
 1?: [LOCALHOST]                                         pmtu 1500
 1:  172.16.12.2                                           1.213ms reached
 1:  172.16.12.2                                           0.828ms reached
     Resume: pmtu 1500 hops 1 back 1 
    
[root@testServer1 vagrant]# tracepath 172.16.12.6
 1?: [LOCALHOST]                                         pmtu 1500
 1:  172.16.12.6                                           0.992ms reached
 1:  172.16.12.6                                           1.138ms reached
     Resume: pmtu 1500 hops 1 back 1 
     
[root@testServer1 vagrant]# tracepath 172.16.12.9
 1?: [LOCALHOST]                                         pmtu 1500
 1:  172.16.12.9                                           1.426ms reached
 1:  172.16.12.9                                           1.257ms reached
     Resume: pmtu 1500 hops 1 back 1 
    
```
