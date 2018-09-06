#!/bin/bash

pushd spring-music
./gradlew clean assemble
popd

cp -r spring-music/* spring-music-app/

ls spring-music-app/build/