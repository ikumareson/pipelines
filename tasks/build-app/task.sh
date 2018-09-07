#!/bin/bash

pushd spring-music
./gradlew clean assemble
popd

timestamp="$(date +'%Y%m%d%H%M%S')"



tar czvf spring-music-build/spring-music-${timestamp}.tar.gz spring-music