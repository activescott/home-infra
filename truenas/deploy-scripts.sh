#!/bin/bash
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory

rsync -avz --progress --delete "${THISDIR}/scripts/" "/Volumes/scott/scripts/truenas/"
