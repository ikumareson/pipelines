#!/bin/bash

pushd app-repo
./gradlew clean assemble
popd

cp -r app-repo/* spring-music-app/

ls spring-music-app/build/