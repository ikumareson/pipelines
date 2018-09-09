#!/bin/bash

set -e 

#cf api $CF_ENDPOINT --skip-ssl-validation
#cf login -u $CF_USER -p $CF_PASSWORD -o $CF_ORG -s $CF_SPACE

cf apps

GREEN_APP="$(cf a | grep "spring-music-temp.apps.nonprod.dryice01.in.hclcnlabs.com" | awk '{print $1}')"
BLUE_APP="$(cf a | grep "spring-music.apps.nonprod.dryice01.in.hclcnlabs.com" | awk '{print $1}')"

if [ "$BLUE_APP" == "" ]; then
	echo "No 'blue' app exists.. Aborting."
	exit 1
fi

if [ "$GREEN_APP" == "" ]; then
	echo "No 'green' app exists.. Aborting."
	exit 1
fi

if [ "$(echo "$BLUE_APP" | wc -l)" -gt 1 ]; then
	echo "Multiple versions of 'blue' app exist.. Aborting."
	cf apps
	exit 1
fi

if [ "$(echo "$GREEN_APP" | wc -l)" -gt 1 ]; then
	echo "Multiple versions of 'blue' app exist.. Aborting."
	cf apps
	exit 1
fi

echo "Mapping active route to 'green' app."
cf map-route $GREEN_APP apps.nonprod.dryice01.in.hclcnlabs.com --hostname spring-music
cf apps

echo "Unmapping active route from 'blue' app"
cf unmap-route $BLUE_APP apps.nonprod.dryice01.in.hclcnlabs.com --hostname spring-music
echo "Unmapping temp route from 'green' app"
cf unmap-route $GREEN_APP apps.nonprod.dryice01.in.hclcnlabs.com --hostname spring-music-temp
cf apps

echo "Deleting 'blue' app"
cf delete -f $BLUE_APP
cf apps