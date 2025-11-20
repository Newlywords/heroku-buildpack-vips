#!/bin/bash

# set -x
set -e

# Remove existing builds so that unsupported stacks are automatically removed
rm -rf ./build/*.tar.gz

# Remove configuration logs so that unsupported stacks are automatically removed
mkdir -p ./build/configurations
rm -rf ./build/configurations/*.log

STACK_VERSIONS=(22 24)

for stack_version in "${STACK_VERSIONS[@]}"; do
  image_name=libvips-heroku-$stack_version:$VIPS_VERSION
  test_image_name=libvips-heroku-$stack_version-test:$VIPS_VERSION

  echo "Building libvips for heroku-$stack_version..."
  docker buildx build \
    --platform linux/amd64 \
    --load \
    --build-arg VIPS_VERSION=${VIPS_VERSION} \
    --build-arg STACK_VERSION=${stack_version} \
    -t $image_name \
    -f "container/Dockerfile.heroku-$stack_version" \
    container

  mkdir -p build

  docker run --rm -t -v $PWD/build:/build $image_name sh -c 'cp -f /usr/local/build/*.tar.gz /build && cp -f /usr/local/build/*.config.log /build/configurations'

  echo "Testing heroku-$stack_version tarball..."
  docker buildx build \
    --platform linux/amd64 \
    --load \
    --build-arg STACK_VERSION=${stack_version} \
    --build-arg TARBALL_PATH=build/heroku-${stack_version}.tar.gz \
    -t $test_image_name \
    -f container/Dockerfile.test \
    .

  echo "✓ heroku-$stack_version build and test completed successfully"
done
