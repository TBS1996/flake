#!/bin/sh
echo "wtf the current date and time: $(date)" >> /home/tor/date_log.txt

cd /home/tor/velv
git add .
git commit -m 'autocommit'
git push

