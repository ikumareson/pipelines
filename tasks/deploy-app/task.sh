#!/bin/bash

set -e 

tar xzvf build-store/*.tgz

pushd spring-music
cf api $CF_ENDPOINT --skip-ssl-validation
cf login -u $CF_USER -p $CF_PASSWORD -o $CF_ORG -s $CF_SPACE
cf apps
cf push
cf apps
popd
