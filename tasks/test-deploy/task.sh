#!/bin/bash


set -e 

echo "Testing blue app "

curl -sSf -m 5 http://spring-music.apps.nonprod.dryice01.in.hclcnlabs.com > /dev/null

if [ $? -eq 0 ]; then
	echo "App Tested OK "
fi
echo "Testing green app "

curl -sSf -m 5 http://spring-music-temp.apps.nonprod.dryice01.in.hclcnlabs.com > /dev/null

if [ $? -eq 0 ]; then
	echo "App Tested OK "
fi
