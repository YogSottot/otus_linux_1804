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
    
    Раскомментировать параметры в /etc/sysconfig/spawn-fcgi и добавить /etc/systemd/system/spawn-fcgi.service
    ```bash
    [Unit]
    Description=Spawn FastCGI scripts to be used by web servers
    After=syslog.target network.target
    
    [Service]
    Type=forking
    EnvironmentFile=/etc/sysconfig/spawn-fcgi
    ExecStart=/usr/bin/spawn-fcgi $OPTIONS
    
    [Install]
    WantedBy=multi-user.target
    ```

3. Дополнить юнит-файл apache httpd возможностью запустить несколько инстансов сервера с разными конфигами

    Добавить в /etc/systemd/system/httpd.service.d/override.conf 
    ```bash
    
    ```

4. Скачать демо-версию Jira и переписать основной скрипт запуска на unit-файл

    ```bash
    [Unit] 
    Description=Jira
    After=network.target
    
    [Service] 
    Type=forking
    User=jira
    PIDFile=/opt/atlassian/jira/work/catalina.pid
    ExecStart=/opt/atlassian/jira/bin/start-jira.sh
    ExecStop=/opt/atlassian/jira/bin/stop-jira.sh
    ExecReload=/opt/atlassian/jira/bin/stop-jira.sh | sleep 60 | /opt/atlassian/jira/bin/start-jira.sh
    
    [Install] 
    WantedBy=multi-user.target 
    ```