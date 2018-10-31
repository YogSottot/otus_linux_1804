#!/bin/sh
HOST='ftp.example.com'
USER='yourid'
PASSWD='yourpw'
FILE='file.txt'

ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
binary
put $FILE
quit
END_SCRIPT
exit 0
