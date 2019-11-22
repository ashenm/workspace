#!/usr/bin/env sh
# Configure Build Environment

set -e

# fetch shims
mkdir --parent filesystem/usr/local/bin && \
curl --silent --show-error --location --output filesystem/usr/local/bin/tree \
  --url https://raw.githubusercontent.com/ashenm/environment/master/linux/bin/tree

# clinch permissions
find filesystem -type d -exec chmod 755 {} \;
find filesystem/etc -type f -exec chmod 644 {} \;
find filesystem/etc/sudoers.d -type d -exec chmod 750 {} \;
find filesystem/etc/profile.d -type f -exec chmod 755 {} \;
find filesystem/etc/sudoers.d -type f -exec chmod 440 {} \;
find filesystem/usr/local/sbin -type f -exec chmod 755 {} \;
find filesystem/usr/local/bin -type f -exec chmod 755 {} \;
