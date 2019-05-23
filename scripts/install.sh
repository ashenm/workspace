#!/usr/bin/env sh
# Configure Build Environment

set -e

# clinch permissions
find filesystem -type d -exec chmod 755 {} \;
find filesystem/etc -type f -exec chmod 644 {} \;
find filesystem/etc/sudoers.d -type d -exec chmod 750 {} \;
find filesystem/etc/profile.d -type f -exec chmod 755 {} \;
find filesystem/etc/sudoers.d -type f -exec chmod 440 {} \;
find filesystem/usr/local/bin -type f -exec chmod 755 {} \;
