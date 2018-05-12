###Домашнее задание
####Пишем скрипт
подготовить свои скрипты для решения следующих кейсов

1) watchdog с перезагрузкой процесса/сервиса
2) watchdog с отсылкой емэйла

3) анализ логов веб сервера/security лога - (на взлом/скорость ответа/выявление быстрых - медленных запросов, анализ IP адресов и кол-ва запросов от них)
    
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

желательно чтобы в скрипте были
циклы
условия
регекспы
awk
наличие в скрипте трапов и функций