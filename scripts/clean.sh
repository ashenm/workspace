#!/usr/bin/env sh

set -e

# remove only `alpha-` tags
# if not explicitly specified
test "$1" = "-a" \
  -o "$1" = "--all" \
    && TRAVIS_BRANCH="*"

# remove all `BUILD_TARGET` images
docker images --all --filter reference="${TRAVIS_REPO_SLUG:-ashenm/workspace}:${TRAVIS_BRANCH:-latest-alpha}" \
  | awk 'NR>1 { print $3 }' \
  | xargs -r docker rmi
