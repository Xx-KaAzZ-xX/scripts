#!/bin/bash

## Description : Watch a connection and modify a file if a connection is 
## made. Then Inotify watchs the file and send an alert by email (cf incrontab -e)

script="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
port="444"
file="/tmp/connections.txt"
file2="/tmp/test.txt"

if [ -z "$1" ]
then
  echo "Usage : ${script} -p <port> or --port <port>"
fi

case "$1" in
  -h | --help)
    echo "Usage : ${script} -p <port> or --port <port>"
    ;;
  -p | --port)
    ##Surveille les co entrantes , si une ligne est ajoutée , alors modif du file2
    while true; do
    lsof -i :${port} | grep ESTABLISHED > ${file}
    before="$(wc -l ${file} | awk '{printf $1}')"
    after="$(wc -l ${file} | awk '{printf $1}')"
    
    echo "before : $before"
    echo "after : $after"
      if [ "$after" -gt "$before" ]
        then
        echo "New connection" > ${file2}
      fi
    sleep 10
done
    ;;
esac

exit 0
