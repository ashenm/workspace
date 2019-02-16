#!/usr/bin/env sh
# Assess Docker Image

set -e

# docker image test suite
git clone --depth 1 https://github.com/docker-library/official-images.git ~/official-images

# test image
~/official-images/test/run.sh -c ~/official-images/test/config.sh -c tests/config.sh "$TRAVIS_REPO_SLUG"

