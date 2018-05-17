### Домашнее задание
#### Systemd

1. **Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig**

    Помещаем в /etc/systemd/system/logwatch.service
    
    ```
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
    Помещаем в /etc/sysconfig/logwatch
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
2. **Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.**
    
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

3. **Дополнить юнит-файл apache httpd возможностью запустить несколько инстансов сервера с разными конфигами**

    Можно использовать систему шаблонов.
    
    Скопируем юнит, для создания шаблона.
    ```bash
    cp /etc/systemd/system/multi-user.target.wants/httpd.service /etc/systemd/system/httpd@.service
    ```
    Так как по условиям ДЗ нужно использовать систему оверрайдов, создадим директорию для оверрайда   
    ```bash
    mkdir /etc/systemd/system/httpd@.service.d/
    ```
    Поместим туда файл override.conf c содержимым
    ```bash
    [Service]
    EnvironmentFile=/etc/sysconfig/httpd-%i
    ```
    Теперь можно запускать новые копии апача
    ```bash
    systemctl daemon-reload
    systemctl start httpd@new.service
    ```
    При этом, предварительно должны быть созданы конфиги вида: ```/etc/sysconfig/httpd-{имя}```, внутри которых должен быть указан путь к конфигу отдельного инстанса апача.
     ```bash
     OPTIONS="-f /etc/httpd/conf/httpd-new.conf"
     ```  

4. **Скачать демо-версию Jira и переписать основной скрипт запуска на unit-файл**
    [Jira Core Server](https://ru.atlassian.com/software/jira/core/download)
    
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

    ```bash
        JIRA starting...                                                                                                                                                                                 [204/1876]
    ****************
    
2018-05-17 15:07:56,891 JIRA-Bootstrap INFO      [c.a.jira.startup.JiraStartupLogger] 
    
    ___ Environment _____________________________
    
         JIRA Build                                    : 7.9.2#79002-sha1:3bb15b68ecd99a30eb364c4c1a393359bcad6278
         Build Date                                    : Wed May 09 00:00:00 MSK 2018
         JIRA Installation Type                        : Standalone
         Application Server                            : Apache Tomcat/8.5.6 - Servlet API 3.1
         Java Version                                  : 1.8.0_102 - Oracle Corporation
         Current Working Directory                     : /
         Maximum Allowable Memory                      : 683MB
         Total Memory                                  : 485MB
         Free Memory                                   : 435MB
         Used Memory                                   : 50MB
         Memory Pool: Code Cache                       : Code Cache: init = 2555904(2496K) used = 8925504(8716K) committed = 10813440(10560K) max = 251658240(245760K)
         Memory Pool: Metaspace                        : Metaspace: init = 0(0K) used = 21904888(21391K) committed = 22675456(22144K) max = -1(-1K)
         Memory Pool: Compressed Class Space           : Compressed Class Space: init = 0(0K) used = 2566144(2506K) committed = 2752512(2688K) max = 1073741824(1048576K)
         Memory Pool: PS Eden Space                    : PS Eden Space: init = 100663296(98304K) used = 33562576(32775K) committed = 212860928(207872K) max = 213385216(208384K)
         Memory Pool: PS Survivor Space                : PS Survivor Space: init = 16777216(16384K) used = 0(0K) committed = 27262976(26624K) max = 27262976(26624K)
        Memory Pool: PS Old Gen                       : PS Old Gen: init = 268435456(262144K) used = 23477168(22926K) committed = 268435456(262144K) max = 536870912(524288K)
           JVM Input Arguments                           : -Djava.util.logging.config.file=/opt/atlassian/jira/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Xms384m
    -Xmx768m -Djava.awt.headless=true -Datlassian.standalone=JIRA -Dorg.apache.jasper.runtime.BodyContentImpl.LIMIT_BUFFER=true -Dmail.mime.decodeparameters=true -Dorg.dom4j.factory=com.atlassian.core.xml.Inter
    ningDocumentFactory -XX:-OmitStackTraceInFastThrow -Datlassian.plugins.startup.options= -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -Xloggc:/opt/atlassian/
    jira/logs/atlassian-jira-gc-%t.log -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=20M -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:+PrintGCCause -Dcatalina.base
    =/opt/atlassian/jira -Dcatalina.home=/opt/atlassian/jira -Djava.io.tmpdir=/opt/atlassian/jira/temp
             Java Compatibility Information                : JIRA version = 7.9.2, Java Version = 1.8.0_102

    ```