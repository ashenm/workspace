#!/usr/bin/env sh
# Build Docker Image

exec docker build -t "${TRAVIS_REPO_SLUG:-ashenm/workspace}:${TRAVIS_BRANCH:-latest-alpha}" .
