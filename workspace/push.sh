#!/usr/bin/env sh
# Copy CWD to Workspace

set -e

umask 0077

# construct target path
TERMINUS="/mnt/workspace/${WORKSPACE##*\\}"

# tarball source
tar --create --owner 1000 --group 1000 --mode a=,u=rwX \
  --exclude .git --file /tmp/workspce.tar .

# create destination folder
mkdir --parent $TERMINUS && \
  chown 1000:1000 $TERMINUS

# update workspace volume
tar --extract --preserve-permissions --same-owner --verbose \
  --strip-components 1 --file /tmp/workspce.tar --directory $TERMINUS
