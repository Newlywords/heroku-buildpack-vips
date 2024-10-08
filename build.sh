#!/bin/bash

# set -x
set -e

# Remove existing builds so that unsupported stacks are automatically removed
rm -rf ./build/*.tar.gz

# Remove configuration logs so that unsupported stacks are automatically removed
mkdir -p ./build/configurations
rm -rf ./build/configurations/*.log

STACK_VERSIONS=(22)

for stack_version in "${STACK_VERSIONS[@]}"; do
  image_name=libvips-heroku-$stack_version:$VIPS_VERSION

  echo "Building ${image_name}"

  docker build \
    --build-arg "VIPS_VERSION=${VIPS_VERSION}" \
    --build-arg "STACK_VERSION=${stack_version}" \
    --platform linux/amd64 \
    -t "${image_name}" \
    -f "container/Dockerfile.heroku-$stack_version" \
    container

  mkdir -p build

  docker run \
    --rm -t \
    --platform linux/amd64 \
    -v "${PWD}/build:/build" "${image_name}" \
    sh -c 'cp -f /usr/local/build/*.tar.gz /build && cp -f /usr/local/build/*.config.log /build/configurations'
done
