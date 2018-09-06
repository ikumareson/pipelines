#!/bin/bash

set -e 

pushd spring-music-app
cf api $CF_ENDPOINT --skip-ssl-validation
cf login -u $CF_USER -p $CF_PASSWORD -o $CF_ORG -s $CF_SPACE
cf apps
cf push
cf apps
popd
