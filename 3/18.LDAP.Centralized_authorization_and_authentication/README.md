### Домашнее задание
#### LDAP

1 **Установить FreeIPA**  

В playbook добавлены роли: 
- freeipa-server
- freeipa-client
- ipa-hosts

Чтобы открыть веб-интерфейс, на хосте нужно добавить в hosts:
```bash
192.168.0.254 centralserver.otus.lan
```
ipa-server установлен на centralserver.  
Порт 443 проброшен на inetrouter2  
Inetrouter2 доступен с хоста по ip 192.168.0.254  

![freeipa](https://i.imgur.com/o5Nw54N.png)


2 **Написать playbook для конфигурации клиента**  

Написан. 

3 **Всю "сетевую лабораторию" перевести на аутентификацию через LDAP**  

Добавлен пользователь
![freeipa](https://i.imgur.com/IaLVlss.png)

4 **Настроить авторизацию по ssh-ключам**  

```bash
/etc/ssh/sshd_config:
AuthorizedKeysCommand /usr/bin/sss_ssh_authorizedkeys
AuthorizedKeysCommandUser nobody
```
```bash
[vagrant@inetrouter2 ~]$ sudo su test_user
sh-4.2$ sh-4.2$ ssh -v centralrouter.otus.lan  
OpenSSH_7.4p1, OpenSSL 1.0.2k-fips  26 Jan 2017
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 62: Applying options for *
debug1: Executing proxy command: exec /usr/bin/sss_ssh_knownhostsproxy -p 22 centralrouter.otus.lan
debug1: SELinux support enabled
Could not create directory '/home/test_user/.ssh'.
debug1: key_load_public: No such file or directory
debug1: identity file /home/test_user/.ssh/id_rsa type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/test_user/.ssh/id_rsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/test_user/.ssh/id_dsa type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/test_user/.ssh/id_dsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/test_user/.ssh/id_ecdsa type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/test_user/.ssh/id_ecdsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/test_user/.ssh/id_ed25519 type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/test_user/.ssh/id_ed25519-cert type -1
debug1: Enabling compatibility mode for protocol 2.0
debug1: Local version string SSH-2.0-OpenSSH_7.4
debug1: permanently_drop_suid: 1627800003
debug1: Remote protocol version 2.0, remote software version OpenSSH_7.4
debug1: match: OpenSSH_7.4 pat OpenSSH* compat 0x04000000
debug1: Authenticating to centralrouter.otus.lan:22 as 'test_user'
debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
debug1: kex: algorithm: curve25519-sha256
debug1: kex: host key algorithm: ecdsa-sha2-nistp256
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: curve25519-sha256 need=64 dh_need=64
debug1: kex: curve25519-sha256 need=64 dh_need=64
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
debug1: Server host key: ecdsa-sha2-nistp256 SHA256:SLDWoNOufqukZJVT65mr9fhADCgR5mq5vabh8H+US2o
debug1: Host 'centralrouter.otus.lan' is known and matches the ECDSA host key.
debug1: Found key in /var/lib/sss/pubconf/known_hosts:3
debug1: rekey after 134217728 blocks
debug1: SSH2_MSG_NEWKEYS sent
debug1: expecting SSH2_MSG_NEWKEYS
debug1: SSH2_MSG_NEWKEYS received
debug1: rekey after 134217728 blocks
debug1: SSH2_MSG_EXT_INFO received
debug1: kex_input_ext_info: server-sig-algs=<rsa-sha2-256,rsa-sha2-512>
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug1: Authentications that can continue: publickey,gssapi-keyex,gssapi-with-mic,keyboard-interactive
debug1: Next authentication method: gssapi-keyex
debug1: No valid Key exchange context
debug1: Next authentication method: gssapi-with-mic
debug1: Authentication succeeded (gssapi-with-mic).
Authenticated to centralrouter.otus.lan (via proxy).
debug1: channel 0: new [client-session]
debug1: Requesting no-more-sessions@openssh.com
debug1: Entering interactive session.
debug1: pledge: proc
debug1: client_input_global_request: rtype hostkeys-00@openssh.com want_reply 0
debug1: Sending environment.
debug1: Sending env LC_MONETARY = en_US.UTF-8
debug1: Sending env LC_NUMERIC = ru_RU.UTF-8
debug1: Sending env LANG = en_GB.UTF-8
debug1: Sending env LC_MEASUREMENT = C
debug1: Sending env LANGUAGE = 
debug1: Sending env LC_TIME = en_GB.UTF-8
Last login: Mon Jul 23 14:26:58 2018 from 192.168.255.5


sh-4.2$ ssh centralserver.otus.lan
Last login: Mon Jul 23 14:17:35 2018 from 192.168.255.5

-sh-4.2$ ssh inetrouter2.otus.lan
Last login: Mon Jul 23 14:21:11 2018
```
