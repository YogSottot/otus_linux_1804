#!/usr/bin/env bash

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


$PGREP ${SERVICE1}
if [ $? -ne 0 ]
    then
    ${RESTART}
fi