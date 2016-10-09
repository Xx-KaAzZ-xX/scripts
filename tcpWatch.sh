#!/bin/bash

## Description : Watch a connection and modify a file if a connection is 
## made. Then Inotify watchs the file and send an alert by email (cf incrontab -e)

port="444"
file="/tmp/connections.txt"
file2="/tmp/test.txt"

while true; do

  lsof -i :${port} | grep ESTABLISHED > ${file}
  before="$(wc -l ${file} | awk '{printf $1}')"
  after="$(wc -l /tmp/connections.txt | awk '{printf $1}')"
  
  if [ ${after} > ${before} ]
  then
    echo "New connection" > ${file2}
  fi
sleep 5
done


exit 0
