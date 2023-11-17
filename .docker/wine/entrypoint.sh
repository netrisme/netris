#!/bin/bash
# Configure timezone
ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
echo "${TZ}" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

echo "Waiting for X server"
until [[ -e /var/run/appconfig/xserver_ready ]]; do sleep 1; done
echo "X server is ready"

#TODO: explicitly set the wine prefix
# Start Wine application
wine /game/"$@"