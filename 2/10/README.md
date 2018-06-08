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

C клиента testClient1/2 можно попасть ssh на сервер testServer1/2 без пароля.

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

Если eth1 и eth2 размещены в разных internal сетях virtualbox, то пинг не проходит, при отключении eth1
Если eth1 и eth2 размещены в одной internal сети virtualbox, то пинг проходит, при отключении eth1
