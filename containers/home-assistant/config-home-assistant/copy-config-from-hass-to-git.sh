#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory

GIT_DIR=$THISDIR
HASS_DIR=admin@bitbox:/share/CACHEDEV1_DATA/app-data/home-assistant

rsync -v --times "$HASS_DIR/*.yaml" "$GIT_DIR/"
