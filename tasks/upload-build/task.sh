#!/bin/bash
set -e

mkdir -p compressed-build

timestamp="$(date +'%Y%m%d%H%M%S')"

tar czvf compressed-build/app-build-${timestamp}.tar.gz spring-music-app
