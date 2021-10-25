#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory

GIT_DIR=$THISDIR
HASS_DIR=admin@bitbox:/share/CACHEDEV1_DATA/app-data/home-assistant

RSYNC_OPTIONS='-v --recursive --delete --times --exclude-from=rsync-excluded-files'
rsync --dry-run $RSYNC_OPTIONS "$GIT_DIR/" "$HASS_DIR/"

while true; do
    printf "\n"
    read -p "Above is a list of changes do you want to continue? (yes or no)" yn
    case $yn in
        [Yy]* ) rsync $RSYNC_OPTIONS "$GIT_DIR/" "$HASS_DIR/"; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
