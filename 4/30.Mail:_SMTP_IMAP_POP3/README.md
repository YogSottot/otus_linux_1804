### Домашнее задание
#### Почта

**Почта**  
1. Установить в виртуалке postfix+dovecot для приёма почты на виртуальный домен любым обсужденным на семинаре способом  

2. Отправить почту телнетом с хоста на виртуалку  

```bash
>telnet 192.168.0.254 25
Trying 192.168.0.254...
Connected to 192.168.0.254.
Escape character is '^]'.
220 mail.otus.com ESMTP
HELO otusadmin.test
250 mail.otus.com
MAIL FROM: <yogsottoth@otusadmin.test>
250 2.1.0 Ok
RCPT TO: <user1@otus.com>
250 2.1.5 Ok
DATA
354 End data with <CR><LF>.<CR><LF>
Subject: Test mail

Test mail for testing purpose.   
.
250 2.0.0 Ok: queued as 63BED60004F2
QUIT
221 2.0.0 Bye
Connection closed by foreign host.
```

3. Принять почту на хост почтовым клиентом  

Подключил аккаунт в thunderbird


**Результат**  
1. Полученное письмо со всеми заголовками  

```bash
Return-Path: <yogsottoth@otusadmin.test>
Delivered-To: <user1@otus.com>
Received: from mail.otus.com
	by mail.otus.ru (Dovecot) with LMTP id W8trGf2+m1sfOgAAcirHDw
	for <user1@otus.com>; Fri, 14 Sep 2018 14:01:26 +0000
Received: from otusadmin.test (unknown [192.168.0.2])
	by mail.otus.com (Postfix) with SMTP id 63BED60004F2
	for <user1@otus.com>; Fri, 14 Sep 2018 13:59:48 +0000 (UTC)
Subject: Test mail

Test mail for testing purpose.
```

![mail](https://i.imgur.com/AFzeOJy.png)

2. Конфиги postfix и dovecot  

Конфиги в директории [templates](https://github.com/YogSottot/otus_linux_1804/tree/master/4/30.Mail:_SMTP_IMAP_POP3/provisioning/roles/postfix-dovecot/templates)
