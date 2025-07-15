#!/bin/bash

# Only cut internet late at night
hour=$(date +%H)
if [ "$hour" -ge 22 ] || [ "$hour" -lt 5 ]; then
  nmcli radio wifi off
  nmcli device disconnect eth0 2>/dev/null
fi

