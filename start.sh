#!/bin/bash

tightvncserver -geometry $GEOMETRY -name $SESSION_NAME

export DISPLAY=:1

for i in `seq 3`; do
  [ -e /tmp/.X11-unix/X1 ] && break
  sleep 1
done

# start webvnc
(cd /home/test/novnc/utils && ./launch.sh --vnc localhost:5901 &> /dev/null &)

# start chrome-driver
/usr/local/bin/chromedriver --whitelisted-ips='' --port=4444 --verbose  --url-base='/wd/hub'
