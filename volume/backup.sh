#!/usr/bin/env sh
# Backup Workspace

set -e

# create gzip tarball
tar --create --bzip2 --preserve-permissions --verbose \
  --file workspace.tgz --directory /mnt workspace

# vim: set expandtab shiftwidth=2 syntax=sh:
