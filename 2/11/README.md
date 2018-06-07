### Домашнее задание
#### VPN

1. Между двумя виртуалками поднять vpn в режимах
- tun
- tap
Прочуствовать разницу.

Vagrantfile для каждой задачи лежит в соответствующей директории. (tun/tap/ras/ocserv)

Запускать нужно прямо оттуда.

-  TUN

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
```bash
ssh root@10.1.0.2
The authenticity of host '10.1.0.2 (10.1.0.2)' can't be established.
ECDSA key fingerprint is SHA256:RPPCVdgBUKZZeISYR4NeL8GDu2bRJOTinE8NkZ3OiR4.
ECDSA key fingerprint is MD5:fb:0b:32:39:0a:40:e3:f5:6a:65:c8:91:eb:fc:d9:8f.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '10.1.0.2' (ECDSA) to the list of known hosts.
Last login: Tue Jun  5 11:43:00 2018
```
Проверка доступности локалки за клиентом
```bash
[vagrant@openvpn1 ~]$ ping -c 4 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=1.38 ms
64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=1.26 ms
64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=1.23 ms
64 bytes from 192.168.2.1: icmp_seq=4 ttl=64 time=1.22 ms

--- 192.168.2.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 1.220/1.277/1.387/0.070 ms
```
Проверка доступности локалки за сервером
```bash
[vagrant@openvpn2 ~]$ ping -c 4 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=1.36 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=1.26 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=1.23 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=1.30 ms

--- 192.168.1.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 1.234/1.292/1.363/0.060 ms
```
```bash
[root@openvpn1 openvpn]# cat server/openvpn-status.log 
TITLE,OpenVPN 2.4.6 x86_64-redhat-linux-gnu [Fedora EPEL patched] [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Apr 26 2018
TIME,Tue Jun  5 12:53:27 2018,1528203207
HEADER,CLIENT_LIST,Common Name,Real Address,Virtual Address,Virtual IPv6 Address,Bytes Received,Bytes Sent,Connected Since,Connected Since (time_t),Username,Client ID,Peer ID
CLIENT_LIST,client1,192.168.255.2:49890,10.1.0.2,,15614,16925,Tue Jun  5 12:38:22 2018,1528202302,UNDEF,0,0
HEADER,ROUTING_TABLE,Virtual Address,Common Name,Real Address,Last Ref,Last Ref (time_t)
ROUTING_TABLE,192.168.2.0/24,client1,192.168.255.2:49890,Tue Jun  5 12:38:22 2018,1528202302
ROUTING_TABLE,10.1.0.2,client1,192.168.255.2:49890,Tue Jun  5 12:47:48 2018,1528202868
GLOBAL_STATS,Max bcast/mcast queue length,1
END
```

-  TAP

Проверка доступности локалки за сервером.
```bash
[root@openvpn2 openvpn]# ping -c 4 10.1.0.1
PING 10.1.0.1 (10.1.0.1) 56(84) bytes of data.
64 bytes from 10.1.0.1: icmp_seq=1 ttl=64 time=1.29 ms
64 bytes from 10.1.0.1: icmp_seq=2 ttl=64 time=1.15 ms
64 bytes from 10.1.0.1: icmp_seq=3 ttl=64 time=1.20 ms
64 bytes from 10.1.0.1: icmp_seq=4 ttl=64 time=1.32 ms

--- 10.1.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 1.155/1.245/1.321/0.079 ms
[root@openvpn2 openvpn]# ping -c 4 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=1.31 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=1.22 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=1.17 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=1.23 ms

--- 192.168.1.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 1.179/1.235/1.310/0.064 ms
```
Проверка доступности локалки за клиентом
```bash
[root@openvpn1 openvpn]# ssh root@10.1.0.2
The authenticity of host '10.1.0.2 (10.1.0.2)' can't be established.
ECDSA key fingerprint is SHA256:6hPFbMiIGPKsGKAJE0OSnYYF59v/k2odbRSnDd6vkng.
ECDSA key fingerprint is MD5:44:08:cc:dc:84:8d:a2:68:0f:88:80:5e:14:37:b6:aa.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '10.1.0.2' (ECDSA) to the list of known hosts.
Last login: Wed Jun  6 08:27:41 2018 from 192.168.255.1
[root@openvpn2 ~]# ping -c 4 10.1.0.2
PING 10.1.0.2 (10.1.0.2) 56(84) bytes of data.
64 bytes from 10.1.0.2: icmp_seq=1 ttl=64 time=0.012 ms
64 bytes from 10.1.0.2: icmp_seq=2 ttl=64 time=0.052 ms
64 bytes from 10.1.0.2: icmp_seq=3 ttl=64 time=0.031 ms
64 bytes from 10.1.0.2: icmp_seq=4 ttl=64 time=0.057 ms

--- 10.1.0.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 0.012/0.038/0.057/0.017 ms
[root@openvpn2 ~]# ping -c 4 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=0.057 ms
64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=0.055 ms
64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=0.054 ms
64 bytes from 192.168.2.1: icmp_seq=4 ttl=64 time=0.023 ms

--- 192.168.2.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3003ms
rtt min/avg/max/mdev = 0.023/0.047/0.057/0.014 ms
```

2. Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку

Поднят не в virtualbox, а в vps на базе qemu-kvm.

Доступы к серверу в чате.

Описание установки и настройки.

```bash
yum -y  install openvpn easy-rsa
cd /etc/openvpn/
mkdir keys
/usr/share/easy-rsa/3.0.3/easyrsa init-pki
/usr/share/easy-rsa/3.0.3/easyrsa --batch build-ca nopass
/usr/share/easy-rsa/3.0.3/easyrsa gen-dh
/usr/share/easy-rsa/3.0.3/easyrsa  build-server-full server1 nopass
/usr/share/easy-rsa/3.0.3/easyrsa  build-client-full client1 nopass
openvpn --genkey --secret ta.key
mv ta.key keys/
cp pki/ca.crt keys/
cp pki/dh.pem keys/
cp pki/issued/server1.crt keys/
cp pki/private/server1.key keys/
firewall-cmd --permanent --zone=public --add-port=3994/udp && firewall-cmd --reload
sy
iptables -t nat -A POSTROUTING -s 10.1.0.0/24 -o eth0 -j MASQUERADE
systemctl start openvpn-server@server_ras
```
Использован server_ras.conf
```


3. Самостоятельно изучить, поднять ocserv и подключиться с хоста к виртуалке 



