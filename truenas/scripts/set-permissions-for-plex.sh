#!/usr/bin/env sh

set -x

sudo chown -R plex:plex        /mnt/thedatapool/video
sudo chmod -R u=rwX,g=rwX,o=rX /mnt/thedatapool/video

sudo chown -R plex:plex       /mnt/thedatapool/audio
sudo chmod -R u=rwX,g=rwX,o=rX /mnt/thedatapool/audio




