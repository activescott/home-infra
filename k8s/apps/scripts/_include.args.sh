#!/usr/bin/env sh

# Check if THISDIR environment variable is defined
if [[ -z "$THISDIR" ]]; then
    echo "ERROR: THISDIR environment variable is not defined."
    exit 1
fi

APPS_ROOT=`cd $THISDIR/..; pwd`

# Check for required argument
if [ $# -ne 1 ]; then
    die "One arguments required."
fi

K8S_APP_NAME="$1"
RESOURCE_ROOT="$APPS_ROOT/$K8S_APP_NAME"
# Check if directories exist
if [ ! -d "$RESOURCE_ROOT" ]; then
    echo "Error: The app name '$K8S_APP_NAME' does not exist."
    exit 1
fi
