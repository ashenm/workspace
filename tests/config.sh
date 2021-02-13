#!/usr/bin/env bash

set -e

imageTests+=(
  [ashenm/workspace]='
    node-hello-world
    perl-hello-world
    plantuml
    plantuml-dot
    php-hello-world
    ruby-hello-world
  '
)
