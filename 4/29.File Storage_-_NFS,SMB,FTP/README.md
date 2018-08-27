### Домашнее задание
#### NFS или SAMBA на выбор

Выбран NFS  

- **vagrant up должен поднимать 2 виртуалки: сервер и клиент**  
Поднимает  

- **на сервер должна быть расшарена директория**  
расшарена директория /mnt/otus_share/  

- **на клиента она должна автоматически монтироваться при старте ( fstab или autofs)**  
```bash
192.168.100.11:/mnt/otus_share/ /mnt/otus_share/ nfs rw,sync,nfsvers=3 0 0
192.168.100.11:/mnt/otus_share/upload /mnt/otus_share/upload nfs rw,sync,nfsvers=3 0 0
```
- **в шаре должна быть папка upload с правами на запись**  
Есть.
```bash
[vagrant@slave ~]# echo test > /mnt/otus_share/upload/test
[vagrant@slave ~]# 

[vagrant@master ~]$ cat /mnt/otus_share/upload/test 
test
```
- **требования для NFS: NFSv3 по UDP, включенный firewall**  
Включено.
```bash
[lockd]
 udp-port=20050

[mountd]
 port=20048

[nfsd]
 port=2049
 udp=y
 tcp=n
 vers2=n
 vers3=y
 vers4=n
 vers4.0=n
 vers4.1=n
 vers4.2=n

[statd]
 port=20051
```

```bash
- name: firewalld open nfs
  firewalld:
   service: nfs
   permanent: true
   immediate: true
   state: enabled
   
- name: firewalld open mountd
  firewalld:
   service: mountd
   permanent: true
   immediate: true
   state: enabled
   
- name: firewalld open rpc-bind
  firewalld:
   service: rpc-bind
   permanent: true
   immediate: true
   state: enabled
   
- name: firewalld open rpc-bind
  firewalld:
   port: 2049/udp
   permanent: true
   immediate: true
   state: enabled

- name: firewalld open rpc-bind
  firewalld:
   port: 2049/udp
   permanent: true
   immediate: true
   state: enabled
   
- name: firewalld open rpc-bind
  firewalld:
   port: 20050/udp
   permanent: true
   immediate: true
   state: enabled

- name: firewalld open rpc-bind
  firewalld:
   port: 20051/udp
   permanent: true
   immediate: true
   state: enabled
```






