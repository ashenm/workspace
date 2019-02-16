#!/usr/bin/env sh
# Build Docker Image

set -e

docker build -t "$TRAVIS_REPO_SLUG" .

