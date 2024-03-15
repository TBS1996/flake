#!/bin/sh
echo "hey the current date and time: $(date)" >> /home/tor/date_log.txt

cd /home/tor/velv
/run/current-system/sw/bin/git add .
/run/current-system/sw/bin/git commit -m 'autocommit'
/run/current-system/sw/bin/git push

