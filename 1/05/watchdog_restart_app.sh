#!/usr/bin/env bash

# Usage example
# ./watchdog_restart_app.sh myapp.pl

if [ "$1" == "" ]; then
echo No service name have been provided.
echo Usage exmaple:
echo
echo -e "./watchdog_restart_app.sh uwsgi"
echo
fi

DATE=`date`
HOSTNAME=`/bin/hostname`

SERVICE1="$1"

until ${SERVICE1}; do
    echo "App ${SERVICE1}' crashed with exit code $?.  Respawning.." >&2
    sleep 1
done