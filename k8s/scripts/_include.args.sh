#!/usr/bin/env bash

# Check if THISDIR environment variable is defined
if [[ -z "$THISDIR" ]]; then
    echo "ERROR: THISDIR environment variable is not defined."
    exit 1
fi

APPS_ROOT=`cd $THISDIR/../apps; pwd`

# Check for required argument
if [ $# -ne 1 ]; then
    die "One arguments required."
fi

K8S_APP_NAME="$1"
RESOURCE_ROOT="$APPS_ROOT/$K8S_APP_NAME"

# Check if directories exist
if [ ! -d "$RESOURCE_ROOT" ]; then
    echo "$RESOURCE_ROOT didn't exist..."
    # it didn't exist as is, but check if it really just wanted the basename (e.g. user typed `./k8s/scripts/preview.sh ./k8s/apps/cert-manager`):
    RESOURCE_ROOT="$APPS_ROOT/`basename $K8S_APP_NAME`"
    echo "trying $RESOURCE_ROOT..."
    if [ ! -d "$RESOURCE_ROOT" ]; then
        # still invalid, so error out
        echo "Error: The app name '$K8S_APP_NAME' does not exist."
        exit 1
    fi   
fi
