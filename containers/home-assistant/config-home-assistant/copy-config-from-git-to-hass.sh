#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory

GIT_DIR=$THISDIR
HASS_DIR=admin@bitbox:/share/CACHEDEV1_DATA/app-data/home-assistant

# NOTE: this requires `shopt -s nullglob` in bash or `set -o nullglob` in zsh. See https://unix.stackexchange.com/a/34012/1862
#rsync --dry-run -v --times "$GIT_DIR/*.yaml" "$HASS_DIR/"

# This is a for because the *.yaml crap doesn't work due to nullglob
for file in "$GIT_DIR/*.yaml"; do rsync -v --times $file "$HASS_DIR/"; done
