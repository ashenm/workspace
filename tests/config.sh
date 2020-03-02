#!/usr/bin/env bash

set -e

imageTests+=(
  [ashenm/workspace]='
    node-hello-world
    perl-hello-world
    plantuml
    plantuml-dot
    ruby-hello-world
  '
)
