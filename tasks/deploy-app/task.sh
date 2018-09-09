#!/bin/bash
 
tar xzvf build-store/*.tar.gz

pushd spring-music 

cf api $CF_ENDPOINT --skip-ssl-validation
cf login -u $CF_USER -p $CF_PASSWORD -o $CF_ORG -s $CF_SPACE

cf check-route spring-music apps.nonprod.dryice01.in.hclcnlabs.com| grep "does not exist"
if [ $? -eq 0 ]; then
	echo "Creating route - spring-music.apps.nonprod.dryice01.in.hclcnlabs.com"
	cf create-route dev apps.nonprod.dryice01.in.hclcnlabs.com --hostname spring-music
fi

cf check-route spring-music-temp apps.nonprod.dryice01.in.hclcnlabs.com | grep "does not exist"
if [ $? -eq 0 ]; then
	echo "Creating route - spring-music-temp.apps.nonprod.dryice01.in.hclcnlabs.com"
	cf create-route dev apps.nonprod.dryice01.in.hclcnlabs.com --hostname spring-music-temp
fi

set -e 

BLUE_APP="$(cf a | grep "^spring-music" | awk '{print $1}')"

if [ "$(echo "$BLUE_APP" | wc -l)" -gt 1 ]; then
	echo "Multiple versions of app exist.. Aborting Deploy."
	cf apps
	exit 1
fi

if [ "$BLUE_APP" == "" ]; then
	echo "No version of app exists.. Running New Deploy."

	timestamp="$(date +'%Y%m%d%H%M%S')"
	cf push spring-music_$timestamp --no-route
	cf map-route spring-music_$timestamp apps.nonprod.dryice01.in.hclcnlabs.com --hostname spring-music

	cf apps
else
	timestamp="$(date +'%Y%m%d%H%M%S')"
	GREEN_APP="spring-music_$timestamp"
	echo "Found 'blue' app $BLUE_APP, deploying 'green' app $GREEN_APP"
	cf push $GREEN_APP --no-route
	cf map-route $GREEN_APP apps.nonprod.dryice01.in.hclcnlabs.com --hostname spring-music-temp
fi
cf apps
popd