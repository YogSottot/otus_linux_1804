### Домашнее задание
#### PAM

1 **Запретить всем пользователям, кроме группы admin логин в выходные и праздничные дни**  

В playbook добавлены пользователи:  
— john, член группы admin с паролем admin  
— james, член групы developer с паролем nonadmin  

```bash
/etc/security/time.conf
*;*;vagrant|james;!SaSu0000-2400
```
```bash
/etc/pam.d/{sshd,login,remote}
account    required     pam_nologin.so
account required pam_time.so
```
Доступ в выходные дни доступен только для root и john.

2 **Дать конкретному пользователю права рута**  


```bash
/etc/pam.d/su
account         sufficient      pam_succeed_if.so uid = 0 use_uid quiet
account         sufficient      pam_succeed_if.so user = john use_uid quiet
account         required        pam_succeed_if.so user notin root:vagrant:john
```
