#!/usr/bin/env sh
# Copy Objects to Workspace

set -e

umask 0077

FILES="${CMD#push}"
VOLUME="/mnt/workspace/"

if [ -z "$FILES" ]
then

  # construct target path
  FOLDER="${WORKSPACE##*\\}"

  # create destination folder
  mkdir --parent $VOLUME/$FOLDER && \
    chown 1000:1000 $VOLUME/$FOLDER

  # tarball CWD content recursively
  tar --create --owner 1000 --group 1000 --mode a=,u=rwX \
    --exclude-vcs --file /tmp/workspace.tar .

  # update workspace volume
  tar --extract --preserve-permissions --same-owner --verbose \
    --strip-components 1 --file /tmp/workspace.tar --directory $VOLUME/$FOLDER

else

  # tarball only specified objects
  tar --create --owner 1000 --group 1000 --mode a=,u=rwX \
    --transform 's/^/.\//' --file /tmp/workspace.tar $FILES

  # update workspace volume
  tar --extract --preserve-permissions --same-owner --verbose \
    --strip-components 1 --file /tmp/workspace.tar --directory $VOLUME

fi

# vim: set expandtab shiftwidth=2 syntax=sh:
