#!/usr/bin/bash
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)

set -x

# based on https://support.plex.tv/articles/200288596-linux-permissions-guide/

# assumes a plex user is created on the host
chown -R plex:plex /mnt/thedatapool/app-data/plex
chown -R plex:plex /mnt/thedatapool/audio
chown -R plex:plex /mnt/thedatapool/video

# fix directories:
find /mnt/thedatapool/audio \
  -type d \
  -exec chmod 755 {} \;

find /mnt/thedatapool/video \
  -type d \
  -exec chmod 755 {} \;

# fix files:
find /mnt/thedatapool/audio \
  -type f \
  -exec chmod 644 {} \;

find /mnt/thedatapool/video \
  -type f \
  -exec chmod 644 {} \;
