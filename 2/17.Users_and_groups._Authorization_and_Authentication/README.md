### Домашнее задание
#### PAM

1 **Запретить всем пользователям, кроме группы admin логин в выходные и праздничные дни**  

В playbook добавлены пользователи:  
— john, член группы admin с паролем admin  
— james, член групы developer с паролем nonadmin  

```bash
/etc/security/time.conf
*;*;!admin;!SaSu0000-2400
```

2 **Дать конкретному пользователю права рута**  


```bash
/etc/pam.d/su
auth sufficient pam_permit.so
```
