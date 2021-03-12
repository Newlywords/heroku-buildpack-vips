#!/bin/bash

# set -x
set -e

docker build --build-arg VIPS_VERSION=${VIPS_VERSION} -t libvips-heroku18:$VIPS_VERSION container

mkdir -p build

docker run --rm -t -v $PWD/build:/build libvips-heroku18:$VIPS_VERSION sh -c 'cp -f /usr/local/vips/build/*.tar.gz /build'
