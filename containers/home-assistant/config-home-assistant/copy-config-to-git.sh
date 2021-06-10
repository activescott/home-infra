#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory

SRC_DIR=admin@bitbox:/share/CACHEDEV1_DATA/app-data/home-assistant

scp "$SRC_DIR/{configuration.yaml,automations.yaml,groups.yaml,scenes.yaml,scripts.yaml,secrets.yaml}" "$THISDIR/"
