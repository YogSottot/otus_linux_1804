### Домашнее задание
#### простая связь через pjsip

- **установить астериск на сервере**  
для установки воспользоваться ролью https://github.com/erlong15/tls-asterisk14-ansible  

при установке создаются 3 номер 1100, 1101, 1102  
подключить два телефона (можно использовать transport-tls, transport-udp, transport-tcp)  
сделать звонок  
в качестве ДЗ принимается лог SIP сессии  

Для запуска zoiper использован x11 forwarding.  

```
config.ssh.forward_x11 = true  
```
```bash
ssh -X -p 2222 vagrant@localhost zoiper
```
