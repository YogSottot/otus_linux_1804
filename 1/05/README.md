### Домашнее задание
#### Пишем скрипт
подготовить свои скрипты для решения следующих кейсов

1) watchdog с перезагрузкой процесса/сервиса
    ```bash
    # Usage example
    # ./watchdog_restart.sh uwsgi

    if [ "$1" == "" ]; then
    echo No service name have been provided.
    echo Usage exmaple:
    echo
    echo -e "./watchdog_restart.sh uwsgi"
    echo
    fi

    SERVICE1=$1
    RESTART="systemctl restart ${SERVICE1}"
    PGREP="/usr/bin/pgrep"
    
    # проверяем запущен ли сервис
    $PGREP ${SERVICE1}
    if [ $? -ne 0 ]
       then
       # перезапускаем
       ${RESTART}
    fi
    ```
2) watchdog с отсылкой емэйла
    ```bash
    # запускать как «скрипт имя_сервиса»
    if [ "$1" == "" ]; then
    echo No service name have been provided.
    echo Usage exmaple:
    echo
    echo -e "./watchdog.sh mysqld"
    echo
    fi
    
    DATE=`date`
    # здесь указать почту для получения уведомлений
    EMAIL=yourmail@mail.com
    HOSTNAME=`/bin/hostname`
    
    SERVICE1="$1"
    SUBJECT="ALERT: ${SERVICE1} is Down..."
    STATUS_CHECKER="/tmp/${SERVICE1}_STATUS_CHECKER.txt"
    
    # Email texts
    MSG_UP="Info: ${SERVICE1} is now UP @ ${DATE} on ${HOSTNAME}"
    MSG_DOWN="Alert: ${SERVICE1} is now DOWN @ ${DATE} on ${HOSTNAME}"
    
    touch ${STATUS_CHECKER}
    
    for SRVCHK in ${SERVICE1}
    do
    # проверяем запущен ли сервис
            PID=$(pgrep ${SERVICE1})
            if [ "$PID" == "" ]; then
                    echo "${SRVCHK} is down"
       # проверяем запись о том, было ли уже отправлено письмо путём сравнения записей
                    if  [ $(grep -c "${SRVCHK}" "${STATUS_CHECKER}") -eq 0 ]; then
       # если ещё не отправляли, пишем в файл и отправляем
                         echo "ALERT: ${SERVICE1} is down at ${DATE} / Sending Email ...."
                         echo ${MSG_DOWN} | mailx -s "${MSG_DOWN}" ${EMAIL}
                            echo "${SRVCHK}" >> ${STATUS_CHECKER}
                    fi
            else
          # если сервис жив, проверяем было ли уже отправлено письмо
                    echo -e "${SRVCHK} is alive and its PID are as follows...\n${PID}"
                    if  [ $(grep -c "${SRVCHK}" "${STATUS_CHECKER}") -eq 1 ]; then
                 # если ещё не отправляли, пишем в файл и отправляем
                           echo "INFO ALERT : ${SERVICE1} is UP at ${DATE} / Sending Email ...."
                           echo ${MSG_UP} | mailx -s "${MSG_UP}" ${EMAIL}
                            sed -i "/${SRVCHK}/d" "${STATUS_CHECKER}"
                    fi
            fi
    done
    ```
3) анализ логов веб сервера/security лога - (на взлом/скорость ответа/выявление быстрых - медленных запросов, анализ IP адресов и кол-ва запросов от них)
        
     Однострочники
     ```
        # получаем список useragent заблокированных ботов.
        grep "] 444" /var/log/nginx/default_access.log | awk -F\" '{print $6}' |  sort | uniq -c  | sort -nr

        # результат
         13 Scrapy/1.4.0 (+http://scrapy.org)
         12 Mozilla/5.0 (compatible; linkdexbot/2.2; +http://www.linkdex.com/bots/)
         9 ltx71 - (http://ltx71.com/)
         8 Mozilla/5.0 (compatible; evc-batch/2.0)
         6 Mozilla/5.0 (compatible; SemrushBot/1.2~bl; +http://www.semrush.com/bot.html)
         5 Mozilla/5.0 zgrab/0.x (compatible; Researchscan/t13rl; +http://researchscan.comsys.rwth-aachen.de)
         4 Mozilla/5.0 (compatible; FemtosearchBot/1.0; http://femtosearch.com)
         3 Mozilla/5.0 zgrab/0.x
         2 Mozilla/5.0 (compatible; MegaIndex.ru/2.0; +http://megaindex.com/crawler)
         2 Mozilla/5.0 (compatible; Exabot/3.0; +http://www.exabot.com/go/robot)
         2 Mozilla/5.0 (compatible; AhrefsBot/5.2; +http://ahrefs.com/robot/)
     ```
     ```bash
        # Ищем успешные входы по ssh
        egrep -i 'accept|success' /var/log/secure
     ```
    
4) крон скрипт с защитой от мультизапуска

    Файл prevent_duplicate.sh
    ```bash
    # указываем путь к pid
    PIDFILE=/var/www/test.pid
    # проверяем его наличие
    if [ -f ${PIDFILE} ]
    then
    # если pid есть, получаем id процесса
      PID=$(cat ${PIDFILE})
    # проверяем наличие процесса по его id
      ps -p ${PID} > /dev/null 2>&1
      if [ $? -eq 0 ]
      then
        echo "Process already running"
        exit 1
      else
        # создаём pid  
        echo $$ > ${PIDFILE}
        # если не получилось, выдаём ошибку
        if [ $? -ne 0 ]
        then
          echo "Could not create PID file"
          exit 1
        fi
      fi
    else
      echo $$ > ${PIDFILE}
      if [ $? -ne 0 ]
      then
        echo "Could not create PID file"
        exit 1
      fi
    fi
    
    # путь к программе, которую нужно запускать по крону без дуплицирования
    /usr/bin/php -f /var/www/domain.tld/exports/test_h.php
    # удаляем pid после завершения программы
    rm ${PIDFILE}
    ```

5) любой скрипт на ваше усмотрение

    Ещё один вариант watchdog.
    В данном случае происходит не мониторинг уже запущенного процесса, но запуск и контроль с помощью watchdog обёртки.
    ```bash
    if [ "$1" == "" ]; then
    echo No service name have been provided.
    echo Usage exmaple:
    echo
    echo -e "./watchdog_restart_app.sh myapp.pl"
    echo
    fi
    
    DATE=`date`
    SERVICE1="$1"
    
    until ${SERVICE1}; do
    # запускаем приложение в петле, и перезапускаем, если завершилось с ошибкой
        echo "App ${SERVICE1}' crashed with exit code $?.  Respawning.." >&2
        sleep 1
    done
    ```
    
Учитывая существование [monit](https://mmonit.com/monit/) и [supervisord](http://supervisord.org/), полезность данных скриптов под большим вопросом.