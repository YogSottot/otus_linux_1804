#!/usr/bin/env bash

# Usage example
# ./watchdog.sh mysqld

if [ "$1" == "" ]; then
echo No service name have been provided.
echo Usage exmaple:
echo
echo -e "./watchdog.sh mysqld"
echo
fi

DATE=`date`
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
        PID=$(pgrep ${SERVICE1})
        if [ "$PID" == "" ]; then
                echo "${SRVCHK} is down"
                if  [ $(grep -c "${SRVCHK}" "${STATUS_CHECKER}") -eq 0 ]; then
                        mailx -s "${MSG_DOWN}" ${EMAIL}
                        echo "${SRVCHK}" >> ${STATUS_CHECKER}
                fi
        else
                echo -e "${SRVCHK} is alive and its PID are as follows...\n${PID}"
                if  [ $(grep -c "${SRVCHK}" "${STATUS_CHECKER}") -eq 1 ]; then
                        mailx -s "${MSG_UP}" ${EMAIL}
                        sed -i "/${SRVCHK}/d" "${STATUS_CHECKER}"
                fi
        fi
done