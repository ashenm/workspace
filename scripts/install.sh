#!/usr/bin/env sh
# Configure Build Environment

set -e

# clinch permissions
find etc -type d -exec chmod 755 {} \;
find etc -type f -exec chmod 644 {} \;
find etc/sudoers.d -type d -exec chmod 750 {} \;
find etc/profile.d -type f -exec chmod 755 {} \;
find etc/sudoers.d -type f -exec chmod 440 {} \;
