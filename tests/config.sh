#!/usr/bin/env bash

set -e

imageTests+=(
  [ashenm/workspace]='
    node-hello-world
    perl-hello-world
    plantuml
    ruby-hello-world
  '
)
