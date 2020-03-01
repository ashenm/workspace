#!/usr/bin/env bash

set -e

imageTests+=(
  [ashenm/workspace]='
    java-hello-world
    java-ca-certificates
    java-uimanager-font
    node-hello-world
    perl-hello-world
    ruby-hello-world
  '
)
