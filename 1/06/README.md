### Домашнее задание
#### Systemd
1. Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig

    Помешаем в /etc/systemd/system/logwatch.service
    ```bash
    [Unit]
    Description=Log watcher

    [Service]
    Type=simple
    EnvironmentFile=/etc/sysconfig/logwatch
    ExecStart=/usr/bin/egrep -i $WORD $LOG
    Restart=on-success
    RestartSec=30s
 
    [Install]
    WantedBy=multi-user.target
    ```
    Помешаем в /etc/sysconfig/logwatch
    ```bash
    # word for search
    WORD=accept
    # path to logfile
    LOG=/var/log/secure
    ```
    ```bash
    systemctl daemon-reload
    systemctl start logwatch.service
    journalctl -f -u logwatch.service 
    ```
    Как вариант, можно использовать timer
    Поместить в /etc/systemd/system/logwatch.timer
    ```bash
    [Unit]
    Description=This is the timer to set the schedule for automated restart of logwatch

    [Timer]
    OnCalendar=*:*:0/10
    AccuracySec=1us

    [Install]
    WantedBy=timers.target
    ```
    В юните поменять 
    ```bash
        Type=oneshot
    
    # и удалить
        Restart=on-success
        RestartSec=30s
    ```
2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.

3. Дополнить юнит-файл apache httpd возможностьб запустить несколько инстансов сервера с разными конфигами

4. Скачать демо-версию Jira и переписать основной скрипт запуска на unit-файл