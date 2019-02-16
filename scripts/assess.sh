#!/usr/bin/env sh
# Locally Assess Docker Image

set -e

# image label
BUILD_TAG="dev"
BUILD_IMAGE="ashenm/workspace"

# override tag if specified
test "$1" = "-t" \
  -o "$1" = "--tag" \
    && BUILD_TAG="${2:?Invalid TAG}"

# ensure folder empty
test -d /tmp/docker-official-images && \
  rm -rf /tmp/docker-official-images

git clone --depth 1 https://github.com/docker-library/official-images.git /tmp/docker-official-images

/tmp/docker-official-images/test/run.sh -c /tmp/docker-official-images/test/config.sh -c tests/config.sh "$BUILD_IMAGE:$BUILD_TAG"

