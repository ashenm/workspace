#!/usr/bin/env sh
# Assess Docker Image

set -e

# docker image test suite
git clone --depth 1 https://github.com/docker-library/official-images.git /tmp/official-images

# test image
/tmp/official-images/test/run.sh -c /tmp/official-images/test/config.sh -c tests/config.sh "${TRAVIS_REPO_SLUG:-ashenm/workspace}:${TRAVIS_BRANCH:-latest-alpha}"

# clean test suite artifacts
rm -rf /tmp/official-images
